require "test_helper"

class TransactionTemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:family_admin)
    sign_in @user
    @transaction = @user.family.transactions.first
    @template = transaction_templates(:one)
  end

  test "should get index" do
    get transaction_templates_url
    assert_response :success
  end

  test "create from transaction" do
    assert_difference("TransactionTemplate.count") do
      post transaction_templates_url, params: { transaction_id: @transaction.id }
    end
    assert_redirected_to transaction_templates_url
  end

  test "show template json" do
    get transaction_template_url(@template, format: :json)
    assert_response :success
    body = response.parsed_body
    assert_equal @template.name, body["name"]
  end
end
