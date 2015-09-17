defmodule Apiv3.EmployeeView do
  use Apiv3.Web, :view

  def render("index.json", %{employees: employees}) do
    %{employees: render_many(employees, "employee.json"),
      pictures: render_pictures(employees)}
  end

  def render("show.json", %{employee: employee}) do
    %{employee: render_one(employee, "employee.json"),
      pictures: render_pictures([employee])}
  end

  def render("employee.json", %{employee: employee}) do
    employee |> ember_attributes |> reject_blank_keys
  end

  defdelegate render_pictures(employee), to: Apiv3.PictureView

  def ember_attributes(employee) do
    %{
      id: employee.id,
      account_id: employee.account_id,
      full_name: employee.full_name,
      title: employee.title,
      arrived_at: employee.arrived_at,
      left_work_at: employee.left_work_at,
      phone: employee.phone,
      email: employee.email,
      tile_type: employee.tile_type,
      tile_id: employee.tile_id,
      createdAt: employee.inserted_at,
      updatedAt: employee.updated_at,
      role: employee.role,
      pictures: just_ids(employee.pictures)
    }
  end
end
