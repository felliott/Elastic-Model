package Elastic::Model::UID;

use Moose;
use MooseX::Types::Moose qw(:all);
use namespace::autoclean;

#===================================
has index => (
#===================================
    is       => 'ro',
    isa      => Str,
    required => 1,
    writer   => '_index'
);

#===================================
has type => (
#===================================
    is       => 'ro',
    isa      => Str,
    required => 1
);

#===================================
has id => (
#===================================
    is     => 'ro',
    isa    => Str,
    writer => '_id'
);

#===================================
has version => (
#===================================
    is     => 'ro',
    isa    => Int,
    writer => '_version'
);

#===================================
has routing => (
#===================================
    is  => 'ro',
    isa => Maybe [Str],
);

#===================================
has from_store => (
#===================================
    is     => 'ro',
    isa    => Bool,
    writer => '_from_store'
);

#===================================
has cache_key => (
#===================================
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    builder => '_build_cache_key',
    clearer => '_clear_cache_key',
);

no Moose;

#===================================
sub new_from_store {
#===================================
    my $class = shift;
    my %params = ref $_[0] ? %{ shift() } : @_;
    $class->new(
        from_store => 1,
        routing    => $params{fields}{routing},
        map { $_ => $params{"_$_"} } qw(index type id version)
    );
}

#===================================
sub update_from_store {
#===================================
    my $self   = shift;
    my $params = shift;
    $self->$_( $params->{$_} ) for qw(_index _id _version);
    $self->_from_store(1);
    $self->_clear_cache_key;
    $self;
}

#===================================
sub update_from_uid {
#===================================
    my $self = shift;
    my $uid  = shift;
    $self->$_( $uid->$_ ) for qw( index routing version );
    $self->_from_store(1);
    $self->_clear_cache_key;
    $self;
}

#===================================
sub read_params  { shift->_params(qw(index type id routing)) }
sub write_params { shift->_params(qw(index type id routing version)) }
#===================================

#===================================
sub _params {
#===================================
    my $self = shift;
    my %vals;
    for (@_) {
        my $val = $self->$_ or next;
        $vals{$_} = $val;
    }
    return \%vals;
}

#===================================
sub _build_cache_key {
#===================================
    my $self = shift;
    return join ";", map { s/;/;;/g; $_ } map { $self->$_ } qw(type id);
}

1;

__END__

# ABSTRACT: The Unique ID of a document in an ElasticSearch cluster

=head1 SYNOPSIS

    $doc = $domain->new_doc(
        $type => {
            id      => $id,             # optional
            routing => $routing,        # optional
            ....
        }
    )
    $uid = $doc->uid

    $doc = $domain->get(
        type    => $type,
        id      => $id,
        routing => $routing,            # optional
    );
    $uid = $doc->uid;

    $index   = $uid->index;
    $type    = $uid->type;
    $id      = $uid->id;
    $version = $uid->version;
    $routing = $uid->routing;

=head1 DESCRIPTION

To truly identify a document as unique in ElasticSearch, you need to know
the C<index> where it is stored, the C<type> of the document, its C<id>, and
possibly its C<routing> value (which defaults to the ID).  Also, each object
has a C<version> number which is incremented on each change.
L<Elastic::Model::UID> wraps up all of these details in an object.

=head1 ATTRIBUTES

=head2 index

The index (or domain) name.  When you create a UID for a new document, you
will create it with C<< index => $domain->name >>, which may be an index
or an alias. However, when you save the document, the C<index> will be
updated to reflect the actual index name.

=head2 type

The type of the document, as specified in L<Elastic::Model::Domain/"types">.

=head2 id

The string ID of the document - if not set when creating a new document, then
an ID is auto-generated when the document is saved.

=head2 routing

The routing string is used to determine in which shard the document lives. If
not specified, then ElasticSearch generates a routing value using a hash of
the ID.  If you use a custom routing value, then you can't change that value
as the new routing B<may> point to a new shard.  Instead, you should delete
the old doc, and create a new doc with the new routing value.

=head2 version

The version is an integer representing the current version of the document.
Each write operation will increment the C<version>, and attempts to update
an older version of the document will throw an exception.

=head2 from_store

A boolean value indicating whether the C<UID> was loaded from ElasticSearch
(C<true>) or created via L</"new()">.

=head2 cache_key

A generated string combining the L</"type"> and the L</"id">

=head1 METHODS

=head2 new()

    $uid = Elastic::Model::Uid->new(
        index   => $domain->name,               # required
        type    => $type,                       # required
        id      => $id,                         # optional
        routing => $routing,                    # optional
    );

Creates a new UID with L</"from_store"> set to false.

=head2 new_from_store()

    $uid = Elastic::Model::UID->new_from_store(
        _index   => $index,
        _type    => $type,
        _id      => $id,
        _version => $version,
        fields   => { routing => $routing }
    );

This is called when creating a new UID for a doc that has been loaded
from ElasticSearch. You shouldn't need to use this method directly.

=head2 update_from_store()

    $uid->update_from_store(
        _index   => $index,
        _id      => $id,
        _version => $version,
    );

When a doc is saved, we update the UID to use the real index name (as opposed
to an alias or domain name), the ID (in case it has been auto-generated)
and the current version number.  It also sets the L</"from_store"> attribute
to C<true>. You shouldn't need to use this method directly.

=head2 update_from_uid()

    $uid->update_from_uid($new_uid);

Updates the L</"index">, L</"routing"> and L</"id"> parameters of one UID
from a newer UID. You shouldn't need to use this method directly.

=head2 read_params()

    $params = $uid->read_params()

Returns a hashref containing L</"index">, L</"type">, L</"id"> and L</"routing">
values.

=head2 write_params()

    $params = $uid->write_params()

Returns a hashref containing L</"index">, L</"type">, L</"id">, L</"routing">
and L</"version"> values.

=cut