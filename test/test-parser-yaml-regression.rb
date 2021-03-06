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

    parser = Kwalify::Yaml::Parser.new
    assert_equal(
      {"foo"=>{"bar"=>{"baz"=>[{"baz_deep"=>"some_text"}]}}},
      parser.parse(content)
      )
    assert_equal([3, 7], parser.location("/foo/bar/baz"))
    assert_equal([4, 7], parser.location("/foo/bar/baz/baz_deep"))
  end

  def test_sequence3
    content = <<-YAML
- A
-
- C
-
-
-
- G
    YAML

    assert_equal(
      ["A", nil, "C", nil, nil, nil, "G"],
      Kwalify::Yaml::Parser.new.parse(content)
      )
  end

  def test_sequence4
    content = <<-YAML
-
  -
    -
    -
    -
-
YAML

    assert_equal(
      [[[nil, nil, nil]], nil],
      Kwalify::Yaml::Parser.new.parse(content)
      )
  end

  def test_sequence5
    content = <<-YAML
- A

-


    - B


-
    YAML

    assert_equal(
      ["A", ["B"], nil],
      Kwalify::Yaml::Parser.new.parse(content)
      )
  end

  def test_sequence6
    content = <<-YAML
A:
- {B1: v1}
- {B2: v2}
- [1, 2, 3]
- B3
- |
  B4
- B5
    YAML

    assert_equal(
      {"A"=>[{"B1"=>"v1"}, {"B2"=>"v2"}, [1, 2, 3], "B3", "B4\n", "B5"]},
      Kwalify::Yaml::Parser.new.parse(content)
      )
  end
end
