defmodule Apiv3.ChangesetUtilsTest do
  use Apiv3.ModelCase
  alias Apiv3.ChangesetUtils

  test "maybe_to_existing_atom" do
    assert ChangesetUtils.maybe_to_existing_atom("account") == :account
    refute ChangesetUtils.maybe_to_existing_atom("jfoadhjisfo90qhwrg9a7hs9g7ahsd9fhasdf")
  end

  @jsonapi %{
    "data" => %{
      "type" => "accounts",
      "attributes" => %{
        "timezone" => "LosAngeles",
        "email" => "x@x.x",
        "company_name"  => "xco"
      },
      "relationships" => %{
        "user" => %{
          "data" => %{
            "id" => 256,
            "type" => "users"
          }
        },
        "appointments" => %{
          "data" => [%{"id" => 3, "type" => "appointments"}]
        },
        "stripe_plan_id" => %{
          "data" => %{
            "id" => "xc",
            "type" => "stripe_plan_id"
          }
        },
        "bad_data" => %{
          "data" => %{
            "id" => "fj23"
          }
        }
      }
    }
  }
  test "activemodel_paramify" do
    assert ChangesetUtils.activemodel_paramify(@jsonapi) == %{
      "timezone" => "LosAngeles",
      "email" => "x@x.x",
      "company_name"  => "xco",
      "user_id" => 256
    }
  end

  test "activemodelify_attributes" do
    attrs = ChangesetUtils.activemodelify_attributes(@jsonapi["data"])
    assert attrs == @jsonapi["data"]["attributes"]
  end

  test "activemodelify_relationships" do
    rels = ChangesetUtils.activemodelify_relationships(@jsonapi["data"], Apiv3.Account)
    assert rels == %{"user_id" => 256}
  end

  test "model_module_from_collection_name" do
    assert Apiv3.Account == ChangesetUtils.model_module_from_collection_name("accounts")
  end
end