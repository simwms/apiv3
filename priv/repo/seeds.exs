# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Apiv3.Repo.insert!(%SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
account_attr = %{
  "service_plan_id" => "test",
  "timezone" => "Americas/Los_Angeles",
  "email" => "test@test.test",
  "access_key_id" => "666hailsatan",
  "secret_access_key" => "ikitsu you na planetarium",
  "region" => "Japan"
}
%Apiv3.Account{}
|> Apiv3.Account.changeset(account_attr) 
|> Apiv3.AccountBuilder.build!
