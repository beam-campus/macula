defmodule SwaiWeb.OurMissionLive.Index do
  use SwaiWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    case connected?(socket) do
      true ->
        {:ok,
         socket
         |> assign(page_title: "Our Mission")}

      false ->
        {:ok,
         socket
         |> assign(page_title: "Our Mission")}
    end
  end

  @impl true
  def handle_info(_msg, socket) do
    {
      :noreply,
      socket
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div
    class="m-10 py-10 px-5 bg-gray-700 bg-opacity-50 rounded-lg shadow-xl"
    id="mission-card"
    >

     <div class="lt-section-header">
     One AI, or another...
     </div>
     <div class="lt-section-text">
     <span>
     Welcome to Swarm Wars, a platform for decentralized, evolutionary computing.
     <br/>
     In recent years, the world has seen a surge in AI applications, with the majority
     being based on generative AI. This approach is great for solving problems where
     the desired outcome is more or less deterministic and models can be trained on large datasets.
     <br/>
     This platform, however, is dedicated to evolutionary computing, also known as
     neuroevolution, a different approach that is inspired by how nature itself works.
      <br/>
     In addition, we try to take it a step further by introducing decentralization and autonomy,
     using algorithms that are inspired by the behavior of social insect species,
     birds, fish and even herding species, which to some extent even includes humans.
     <br/>
     Our mission is to create a community that is interested to further this field,
     with the ideal of being able to apply what we learn to practical problems.
     </span>
     </div>


     <div class="lt-section-header">
     More than a Game
    </div>
    <div class="lt-section-text">
    <span>
    Though Swarm Wars is presented as a game, it is more than just that;
    by introducing competitive and entertaining elements,
    we aim to make the subject matter more accessible and engaging to a broader audience.
    <br/>
    Under the hood, it is rather a sophisticated research tool, designed to explore the complexities and potentials
    of decentralized AI systems and by studying their emergent behaviors and capabilities,
    we grow insights that can be applied to real-world challenges.
    <br/>
    The applicability of genetic algorithms is vast, ranging from optimizing logistics or trade,
    over health and environmental related topics, to enhancing autonomous systems.
    </span>
    </div>



    <div class="lt-section-header">
        We Need You!
    </div>
    <div class="lt-section-text">
    <span>
    We believe that AI should not be the exclusive domain of big tech:
    a democratization that is essential to ensure that expertise is widely distributed and decentralized,
    so that development is guided by a broad spectrum of perspectives and values.
    <br/>
    <a class="text-blue-300 hover:underline" href="https://www.buymeacoffee.com/beamologist">Your support</a> will allow us to build
    an independent and entertaining, though serious tool for research, education and problem-solving.
    </span>
    </div>

    <div class="lt-section-header">
       Why the BEAM?
    </div>
    <div class="lt-section-text">
    <span>
    Our choice for the <a class="text-blue-300 hover:underline" href="https://en.wikipedia.org/wiki/BEAM_(Erlang_virtual_machine)">'BEAM'</a> is no coincidence.
    <br />
    This platform remains unrivalled for building scalable, fault-tolerant distributed systems with requirements for high availability.
    <br />
    In addition, the ecosystem not just offers a number of libraries and tools that are well-suited for building decentralized AI systems,
    it is also very cost-efficient and capable of running on a wide range of hardware, making it resource-friendly and sustainable as well.
    </span>
    </div>
    </div>
    """
  end
end
