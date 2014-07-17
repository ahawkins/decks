require_relative 'test_helper'

module Decks
  class SanitizationTest < MiniTest::Unit::TestCase
    include SanitizationHelpers

    def test_replaces_white_space_with_underscore
      assert_equal 'Markus_Schulz', sanitize('Markus Schulz')
    end

    def test_replaces_ampersand_with_and
      assert_equal 'Above_and_Beyond', sanitize('Above & Beyond')
    end

    def test_drops_whitespace_padding
      assert_equal 'Test', sanitize('  Test  ')
    end

    def test_drops_apstrophes
      assert_equal 'O_Bir', sanitize("O'Bir")
    end

    def test_drops_qoutes
      assert_equal 'Dan_The_Man', sanitize('Dan "The" Man')
    end

    def test_drop_pad_with_underscores
      assert_equal 'Test', sanitize('"Test"')
    end

    def test_does_not_create_two_underscores_in_a_row
      assert_equal 'John_00_Fleming', sanitize("John '00' Fleming")
    end

    def test_replaces_vs_dot_with_vs
      assert_equal 'Fleming_vs_Lawrence', sanitize("Fleming vs. Lawrence")
      assert_equal 'Fleming_vs_Lawrence', sanitize("Fleming Vs. Lawrence")
    end

    def test_jibberish_is_replace_with_underscore
      assert_equal 'Foo', sanitize('Foo!')
      assert_equal 'Foo', sanitize('Foo@')
      assert_equal 'Foo', sanitize('Foo#')
      assert_equal 'Foo', sanitize('Foo$')
      assert_equal 'Foo', sanitize('Foo%')
      assert_equal 'Foo', sanitize('Foo^')
      assert_equal 'Foo', sanitize('Foo*')
      assert_equal 'Foo', sanitize('Foo[')
      assert_equal 'Foo', sanitize('Foo]')
      assert_equal 'Foo', sanitize('Foo{')
      assert_equal 'Foo', sanitize('Foo}')
      assert_equal 'Foo', sanitize('Foo|')
      assert_equal 'Foo', sanitize('Foo/')
      assert_equal 'Foo', sanitize('Foo\\')
      assert_equal 'Foo', sanitize('Foo<')
      assert_equal 'Foo', sanitize('Foo>')
      assert_equal 'Foo', sanitize('Foo,')
      assert_equal 'Foo', sanitize('Foo?')
      assert_equal 'Foo', sanitize('Foo:')
      assert_equal 'Foo', sanitize('Foo;')
    end

    def test_dots_are_allowed
      assert_equal 'Foo.bar', sanitize('Foo.bar')
    end

    def test_parenthesis_are_allowed
      assert_equal 'Foo(bar)', sanitize('Foo(bar)')
    end

    def test_dash_is_allowed
      assert_equal 'Foo-Bar', sanitize('Foo-Bar')
    end

    def test_will_remove_unacceptable_start_of_string_characters
      assert_equal 'Foo', sanitize('-Foo')
      assert_equal 'Foo', sanitize('_Foo')
      assert_equal 'Foo', sanitize('.Foo')
      assert_equal 'Foo', sanitize(')Foo')
      assert_equal '(Foo', sanitize('(Foo')
    end

    def test_will_remove_unacceptable_end_of_string_characters
      assert_equal 'Foo', sanitize('Foo-')
      assert_equal 'Foo', sanitize('Foo_')
      assert_equal 'Foo', sanitize('Foo.')
      assert_equal 'Foo', sanitize('Foo(')
      assert_equal 'Foo)', sanitize('Foo)')
    end

    def test_it_should_transliterate_to_ascii_values
      skip
    end

    # ==== Special Cases Tests =====
    def test_mike_with_dots_become_mike
      assert_equal 'MIKE', sanitize('M.I.K.E.')
      assert_equal 'MIKE', sanitize('m.i.k.e.')
    end
  end
end
