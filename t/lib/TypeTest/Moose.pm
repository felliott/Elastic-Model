package TypeTest::Moose;

use Elastic::Doc;
use Moose::Util::TypeConstraints;

#===================================
has 'any_attr' => (
#===================================
    is  => 'ro',
    isa => 'Any',
);

#===================================
has 'item_attr' => (
#===================================
    is  => 'ro',
    isa => 'Item',
);

#===================================
has 'maybe_attr' => (
#===================================
    is  => 'ro',
    isa => 'Maybe',
);

#===================================
has 'maybe_str_attr' => (
#===================================
    is  => 'ro',
    isa => 'Maybe[Str]',
);

#===================================
has 'undef_attr' => (
#===================================
    is  => 'ro',
    isa => 'Undef',
);

#===================================
has 'defined_attr' => (
#===================================
    is  => 'ro',
    isa => 'Defined',
);

#===================================
has 'value_attr' => (
#===================================
    is  => 'ro',
    isa => 'Value',
);

#===================================
has 'str_attr' => (
#===================================
    is  => 'ro',
    isa => 'Str',
);

#===================================
has 'enum_attr' => (
#===================================
    is  => 'ro',
    isa => enum( [ 'foo', 'bar' ] ),
);

#===================================
has 'num_attr' => (
#===================================
    is  => 'ro',
    isa => 'Num',
);

#===================================
has 'int_attr' => (
#===================================
    is  => 'ro',
    isa => 'Int',
);

#===================================
has 'ref_attr' => (
#===================================
    is  => 'ro',
    isa => 'Ref',
);

#===================================
has 'scalar_ref_attr' => (
#===================================
    is  => 'ro',
    isa => 'ScalarRef',
);

#===================================
has 'scalar_ref_str_attr' => (
#===================================
    is  => 'ro',
    isa => 'ScalarRef[Str]',
);

#===================================
has 'array_ref_attr' => (
#===================================
    is  => 'ro',
    isa => 'ArrayRef',
);

#===================================
has 'array_ref_str_attr' => (
#===================================
    is  => 'ro',
    isa => 'ArrayRef[Str]',
);

#===================================
has 'hash_ref_attr' => (
#===================================
    is  => 'ro',
    isa => 'HashRef',
);

#===================================
has 'hash_ref_str_attr' => (
#===================================
    is  => 'ro',
    isa => 'HashRef[Str]',
);

#===================================
has 'code_ref_attr' => (
#===================================
    is  => 'ro',
    isa => 'CodeRef',
);

#===================================
has 'regexp_ref_attr' => (
#===================================
    is  => 'ro',
    isa => 'RegexpRef',
);

#===================================
has 'glob_ref_attr' => (
#===================================
    is  => 'ro',
    isa => 'GlobRef',
);

#===================================
has 'file_handle_attr' => (
#===================================
    is  => 'ro',
    isa => 'FileHandle',
);

#===================================
has 'union_attr' => (
#===================================
    is  => 'ro',
    isa => union( [ 'Str', 'ArrayRef' ] ),
);

#===================================
has 'type_attr' => (
#===================================
    is  => 'ro',
    isa => type( 'Foo', {} )
);

#===================================
has 'subtype_str_attr' => (
#===================================
    is  => 'ro',
    isa => subtype( 'SubFoo', as('Str') )
);

# object
# class name
# role name
no Elastic::Doc;

1;
