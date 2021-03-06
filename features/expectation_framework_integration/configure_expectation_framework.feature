Feature: configure expectation framework

  By default, RSpec is configured to include rspec-expectations for expressing
  desired outcomes. You can also configure RSpec to use:

  * rspec/expectations (explicitly)
  * stdlib assertions
    * test/unit assertions in ruby 1.8
    * minitest assertions in ruby 1.9
  * rspec/expectations _and_ stlib assertions

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
        config.expect_with :stdlib
      end

      RSpec.describe 5 do
        it "is greater than 4" do
          assert 5 > 4, "expected 5 to be greater than 4"
        end

        specify { assert 5 < 6 }
      end
      """
    When I run `rspec example_spec.rb`
    Then the output should contain "2 examples, 0 failures"

  Scenario: Configure test/unit assertions (failing examples)
    Given a file named "example_spec.rb" with:
      """ruby
      RSpec.configure do |config|
        config.expect_with :stdlib
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

  Scenario: Configure rspec/expecations AND test/unit assertions
    Given a file named "example_spec.rb" with:
      """ruby
      RSpec.configure do |config|
        config.expect_with :rspec, :stdlib
      end

      RSpec.describe 5 do
        it "is greater than 4" do
          assert 5 > 4, "expected 5 to be greater than 4"
        end

        it "is less than 6" do
          expect(5).to be < 6
        end
      end
      """
    When I run `rspec example_spec.rb`
    Then the examples should all pass
