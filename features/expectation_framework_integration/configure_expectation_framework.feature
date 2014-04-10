@wip
Feature: configure expectation framework

  By default, RSpec is configured to include rspec-expectations for expressing
  desired outcomes. You can also configure RSpec to use:

  * rspec/expectations (explicitly)
  * test/unit assertions in ruby 1.8
  * minitest assertions in ruby 1.9
  * rspec/expectations _and_ either test/unit or minitest assertions

  Note that when you do not use rspec-expectations, you must explicitly provide
  a description to every example. You cannot rely on the generated descriptions
  provided by rspec-expectations.

  Scenario: Default configuration uses rspec-expectations
    Given a file named "example_spec.rb" with:
      """ruby
      RSpec::Matchers.define :be_a_multiple_of do |factor|
        match do |actual|
          actual % factor == 0
        end
      end

      RSpec.describe 6 do
        it { is_expected.to be_a_multiple_of 3 }
      end
      """
    When I run `rspec example_spec.rb`
    Then the examples should all pass

  Scenario: Configure rspec-expectations (explicitly)
    Given a file named "example_spec.rb" with:
      """ruby
      RSpec.configure do |config|
        config.expect_with :rspec
      end

      RSpec.describe 5 do
        it "is greater than 4" do
          expect(5).to be > 4
        end
      end
      """
    When I run `rspec example_spec.rb`
    Then the examples should all pass

  Scenario: Configure test/unit assertions (passing examples)
    Given a file named "example_spec.rb" with:
      """ruby
      RSpec.configure do |config|
        config.expect_with :test_unit
      end

      RSpec.describe [1] do
        it "is equal to [1]" do
          assert_equal [1], [1], "expected [1] to equal [1]"
        end

        specify { assert_not_equal [1], [] }
      end
      """
    When I run `rspec example_spec.rb`
    Then the output should contain "2 examples, 0 failures"

  Scenario: Configure test/unit assertions (failing examples)
    Given a file named "example_spec.rb" with:
      """ruby
      RSpec.configure do |config|
        config.expect_with :test_unit
      end

      RSpec.describe 5 do
        it "is greater than 6 (no it isn't!)" do
          assert 5 > 6, "errantly expected 5 to be greater than 5"
        end

        specify { assert 5 > 6 }
      end
      """
    When I run `rspec example_spec.rb`
    Then the output should contain "2 examples, 2 failures"

  Scenario: Configure minitest assertions (passing examples)
    Given a file named "example_spec.rb" with:
      """ruby
      RSpec.configure do |config|
        config.expect_with :minitest
      end

      RSpec.describe "Object identity" do
        it "the an object is the same as itself" do
          x = [1]
          assert_same x, x, "expected x to be the same x"
        end

        specify { refute_same [1], [1] }
      end
      """
    When I run `rspec example_spec.rb`
    Then the output should contain "2 examples, 0 failures"

  Scenario: Configure minitest assertions (failing examples)
    Given a file named "example_spec.rb" with:
      """ruby
      RSpec.configure do |config|
        config.expect_with :minitest
      end

      RSpec.describe [1] do
        it "is empty (no it isn't!)" do
          assert_empty [1], "errantly expected [1] to be empty"
        end

        specify { assert_empty [1] }
      end
      """
    When I run `rspec example_spec.rb`
    Then the output should contain "2 examples, 2 failures"

  Scenario: Configure rspec/expectations AND test/unit assertions
    Given a file named "example_spec.rb" with:
      """ruby
      RSpec.configure do |config|
        config.expect_with :rspec, :test_unit
      end

      RSpec.describe [1] do
        it "is equal to [1]" do
          assert_equal [1], [1], "expected [1] to equal [1]"
        end

        it "matches array [1]" do
          is_expected.to match_array([1])
        end
      end
      """
    When I run `rspec example_spec.rb`
    Then the examples should all pass

  Scenario: Configure rspec/expecations AND minitest assertions
    Given a file named "example_spec.rb" with:
      """ruby
      RSpec.configure do |config|
        config.expect_with :rspec, :minitest
      end

      RSpec.describe "Object identity" do
        it "two arrays are not the same object" do
          refute_same [1], [1]
        end

        it "an array is itself" do
          array = [1]
          expect(array).to be array
        end
      end
      """
    When I run `rspec example_spec.rb`
    Then the examples should all pass
