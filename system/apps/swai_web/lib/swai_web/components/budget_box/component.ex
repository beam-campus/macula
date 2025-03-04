defmodule SwaiWeb.BudgetBox do
  use SwaiWeb, :live_component


  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-between bg-white shadow-md rounded-lg mr-2">
      <span class=" text-xs font-regular text-gray-700 pl-2" id={"budget_info_#{@current_user.id}"}>
        <%= @current_user.budget %> <span> 👾 </span>
        <%!-- <%= if @user.budget <= 0 do %> --%>
        <%!-- <.link
          href={"/populate/#{@current_user.id}"}
          class="bg-swBrand-dark hover:bg-swBrand text-white font-regular py-1 px-3 text-xs rounded-lg transition duration-300 ease-in-out"
          role="button"
          method="get"
          id="button_order_drones"
        > --%>
        <.link
          href={"/mission"}
          class="bg-swBrand-dark hover:bg-swBrand text-white font-regular py-1 px-3 text-xs rounded-lg transition duration-300 ease-in-out"
          role="button"
          method="get"
          id="button_order_drones"
        >
          Populate
        </.link>
       <%!-- <% end %> --%>
        </span>
    </div>
    """
  end
end
