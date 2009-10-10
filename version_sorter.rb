# stolen from http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/53779
module VersionSorter
  extend self

  def sort(list)
    @version_numbers ||= {}
    @version_strings ||= {}
    @infinity = 1.0/0.0
    list.sort_by {|x| normalize(x)}
  end

  def rsort(list)
    sort(list).reverse
  end

private

  def normalize(version)
    version.scan(/(\d+)|([a-z]+)/i).map {|n, s| n ? normal_number(n) : normal_string(s)}
  end

  def normal_number(n)
    n = n.to_i
    @version_numbers[n] || (@version_numbers[n] = [n])
  end

  def normal_string(s)
    @version_strings[s] || (@version_strings[s] = [@infinity, s])
  end

end

puts

if $0 == __FILE__
  require 'test/unit'

  class VersionSorterTest < Test::Unit::TestCase
    include VersionSorter

    def test_sorts_verisons_correctly
      versions = %w(1.0.9 1.0.10 2.0 3.1.4.2 1.0.9a)
      sorted_versions = %w( 1.0.9 1.0.9a 1.0.10 2.0 3.1.4.2 )

      assert_equal sorted_versions, sort(versions)
    end

    def test_reverse_sorts_verisons_correctly
      versions = %w(1.0.9 1.0.10 2.0 3.1.4.2 1.0.9a)
      sorted_versions = %w( 3.1.4.2 2.0 1.0.10 1.0.9a 1.0.9 )

      assert_equal sorted_versions, rsort(versions)
    end
  end

  require 'benchmark'
  versions = ARGF.read.split("\n")
  count = 10
  Benchmark.bm(20) do |x|
    x.report("sort")             { count.times { VersionSorter.sort(versions) } }
    x.report("reverse")          { count.times { VersionSorter.rsort(versions) } }
  end
  puts

end
