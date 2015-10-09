defmodule Apiv3.UserController do
  use Apiv3.Web, :controller
  alias Apiv3.Employee
  alias Apiv3.User
  def show(conn, %{"email" => email}) do
    account = conn |> current_account
    employee = Employee |> Repo.get_by!(account_id: account.id, email: email)
    user = %{account_id: account.id, employee_id: employee.id, email: email}
    conn |> render("show.json", user: user)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    case changeset |> Repo.insert do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end
end