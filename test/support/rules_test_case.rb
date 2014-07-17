module Decks
  class RulesTestCase < MiniTest::Unit::TestCase
    def assert_ok(release)
      assert release.ok?, "Release rules broken: #{release.problems}"
    end

    def refute_ok(release)
      refute release.ok?, "Release should be ok: #{release.problems}"
    end
  end
end
