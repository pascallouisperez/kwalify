require File.dirname(__FILE__) + '/test.rb'

class ParserRegressionTest < Test::Unit::TestCase
  def test_simple_mapping_with_dash
    content = <<-YAML
foo:
  - bar: baz
YAML

    assert_equal(
      {"foo"=>[{"bar"=>"baz"}]},
      Kwalify::Yaml::Parser.new.parse(content)
      )
  end

  def test_deep_mapping_with_dash
    content = <<-YAML
foo:
  bar:
    baz:
    - baz_deep: some_text
YAML

    assert_equal(
      {"foo"=>{"bar"=>{"baz"=>[{"baz_deep"=>"some_text"}]}}},
      Kwalify::Yaml::Parser.new.parse(content)
      )
  end
end
