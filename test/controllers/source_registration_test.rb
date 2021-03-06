require_relative '../test_helper'
require 'pry'

class SourceRegistrationTest < Minitest::Test

  def test_valid_registration_with_identifier_and_rooturl
    init_count = SourceValidator.count

    post('/sources', { identifier: "anIdentifier", rootUrl: "some/root/url" })

    ende_count = SourceValidator.count

    assert_equal 200, last_response.status
    assert_equal "{'identifier':'anIdentifier'}", last_response.body
    assert_equal 1, (ende_count - init_count)
  end


  def test_invalid_registration_with_no_identifier
    init_count = Source.count

    post('/sources', { rootUrl: "some/root/url" } )

    ende_count = Source.count

    assert_equal 400, last_response.status
    assert_equal "Identifier can't be blank", last_response.body
    assert_equal init_count, ende_count
  end

  def test_invalid_registration_with_no_rooturl
    init_count = Source.count

    post('/sources', { identifier: "anIdentifier" } )

    ende_count = Source.count

    assert_equal 400, last_response.status
    assert_equal "Rooturl can't be blank", last_response.body
    assert_equal init_count, ende_count
  end

  def test_invalid_registration_with_existent_identifier
    post('/sources', { identifier: "anIdentifier", rootUrl: "some/root/url" } )

    init_count = Source.count

    post('/sources', { identifier: "anIdentifier", rootUrl: "some/other/url" } )

    ende_count = Source.count

    assert_equal 403, last_response.status
    assert_equal "Identifier has already been taken", last_response.body
    assert_equal init_count, ende_count
  end
end
