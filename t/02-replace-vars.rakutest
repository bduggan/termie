use Test;

use Termie::Commands;

my %*vars = earth => 'world';

my $str = 'hello \\=earth';

replace-vars($str);

is $str, 'hello world', 'replaced a var';

done-testing;

