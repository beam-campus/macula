defmodule SwaiWeb.AboutLive do
  @moduledoc """
  The live view for the about page.
  """
  use SwaiWeb, :live_view

  alias Edges.Service, as: Edges

  @impl true
  def mount(_params, _session, socket) do
    case connected?(socket) do
      true ->
        {:ok,
         socket
         |> assign(
           edges: Edges.get_all(),
           now: DateTime.utc_now(),
           page_title: "Evolutionary AI"
         )}

      false ->
        {:ok,
         socket
         |> assign(
           edges: Edges.get_all(),
           now: DateTime.utc_now(),
           page_title: "Evolutionary AI"
         )}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="font-brand text-white flex flex-col py-5">

    <%!-- <div class="flex-grow"> --%>


     <div class="lt-section-header">
       One AI, or another...
     </div>
     <div class="lt-section-text">
       Swarm Wars is a gamified research and development platform, a playground,
       that will allow investigation of and experimentation with
       emergent aspects and behaviors of decentralized AI.
      <br />
      This is a rather new field, that is still in its infancy, but has the potential to revolutionize the way we think about decentralized computing and AI,
      perhaps even offer an alternative to the current resource-intensive, centralized AI models, that are governed by Big Tech actors.
      <br />
      For this, we invite you to join our community of researchers, developers and enthusiasts,
      who will work together to built a massively distributed and decentralized mesh
      of low-power devices: the Macula Mesh.
      <br />
     </div>

    <div class="lt-section-header">
        Building the Mesh
    </div>
    <div class="lt-section-text">
    It is clear that in order to create this mesh, the help of the community is needed.
    <br />
    Join Macula and contribute to the research in decentralized, evolutionary AI through the game Swarm Wars.
    By hosting a node, you’ll help advance our understanding of distributed computing and AI,
    while being part of a collaborative and innovative project.
    Your participation can make a meaningful impact and together we can explore new frontiers in technology.
     </div>


         <%!-- <div class="lt-section-header">
       Showing some Love
     </div>
     <div class="lt-section-text">
     This initiative depends entirely on crowd funding to sustain and grow.
     If you believe in the potential of this innovative project and want to see it succeed, consider supporting us by buying us a coffee or two.
     Your contribution, no matter how small, helps us cover essential costs and continue our journey towards advancing and democratizing AI technology.
     <br />
     Thank you for your support!
     </div> --%>


    <%!-- <div class="lt-section-header">
        Guilty as charged
    </div>
    <div class="flex px-20" >
    <div class="w-100">
        <img src="/images/raf1.jpg" alt="Beamologist" class="border rounded-full w-50 h-50 border-white" />
    </div>
    <div class="lt-section-text">
        Beamologist, a software engineer with decades of experience in
        developing corporate web- and edge/IoT applications using .NET,
        mostly in logistics- and manufacturing related industries.
        <br />
        Come 2020, he was looking for answers to solve needs in the fields of event-driven architectures,
        decentralized systems and genetic algorithms. This is when he discovered the BEAM ecosystem.
        Ever since, he realized that other platforms would probably
        not be able to offer a similar coverage and quality,
        or even bring the same amount of professional satisfaction.
        This is when he decided to dedicate his time to contribute to initiatives that further the ecosystem.
    </div>
    </div> --%>
    <%!-- </div>     --%>
    </div>
    """
  end
end
