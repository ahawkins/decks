module Decks
  class ScreenTestCase < MiniTest::Unit::TestCase
    class FakeOutput
      def initialize
        @screen = [ ]
      end

      def puts(string)
        @screen << "#{string}\n"
      end

      def print(string)
        @screen << string
      end

      def flush
        @screen.clear
      end

      def to_s
        @screen.join.to_s
      end

      def printf(format, *args)
        print(format % args)
      end
    end

    class FakeScreen
      include Decks::Screen
      include Concord::Public.new(:release)
    end

    attr_reader :router, :terminal, :release, :placeholder

    def setup
      super

      @release = configure do |release|
        release.artist = 'Markus Schulz'
        release.name = 'City Series'
        release.year = 2010
        release.catalogue_number = 'CH238'
        release.format = 'WEB'
        release.track 'track1.mp3' do |track|
          track.number = 1
          track.title = 'Title'
          track.artist = 'Artist'
        end
      end

      @terminal = FakeOutput.new

      @router = Router.new terminal

      @placeholder = FakeScreen.new release
    end

    def assert_choice(view, choice)
      refute view.to_s.empty?, 'Nothing printed to terminal'
      assert_includes view.to_s, "(#{choice.upcase})", "No option #{choice}"
    end

    def assert_printed(view, matcher)
      if Regexp === matcher
        assert_match matcher, view.to_s
      else
        assert_includes view.to_s, matcher.to_s
      end
    end

    def refute_printed(view, matcher)
      if Regexp === matcher
        refute_match matcher, view.to_s
      else
        refute_includes view.to_s, matcher.to_s
      end
    end

    def assert_state(klass, router)
      assert_equal klass, router.state.class
    end
  end
end
