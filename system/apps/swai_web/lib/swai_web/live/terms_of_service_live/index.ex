defmodule SwaiWeb.TermsOfServiceLive.Index do
  use SwaiWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    case connected?(socket) do
      true ->
        {:ok,
         socket
         |> assign(page_title: "Terms of Service")}

      false ->
        {:ok,
         socket
         |> assign(page_title: "")}
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
    <div class="m-10 py-10 px-5 bg-white bg-opacity-50 rounded-lg shadow-xl" id="terms-card">
      <p><strong>Last Updated: July 6, 2024</strong></p>

      <p>Welcome to Swarm Wars! These Terms of Service ("Terms") govern your use of the Swarm Wars website and the services provided ("Services"). By accessing or using our Services, you agree to be bound by these Terms. If you do not agree to these Terms, please do not use our Services.</p>

      <p>Swarm Wars AI is a product created and maintained by DisComCo Sp.z.o.o. For more information, please visit <a id="discomco-link" href="https://discomco.pl" target="_blank">the DisComCo Website</a>.</p>

      <h2 class="mt-4 mb-2 font-semibold">1. Acceptance of Terms</h2>
      <p>By creating an account or using our Services, you agree to comply with and be legally bound by these Terms and our Privacy Policy.</p>

      <h2 class="mt-4 mb-2 font-semibold">2. Account Registration</h2>
      <ul class="list-disc pl-5">
        <li>You must be at least 18 years old to create an account.</li>
        <li>You are responsible for maintaining the confidentiality of your account information, including your password, and for all activities that occur under your account.</li>
      </ul>

      <h2 class="mt-4 mb-2 font-semibold">3. Services Provided</h2>
      <p>Swarm Wars allows users to run swarms of individual workers executing genetic algorithms. Users can obtain tokens to use these services either by purchasing them or by contributing computing power by adding nodes to the Macula mesh.</p>

      <h2 class="mt-4 mb-2 font-semibold">4. Tokens</h2>
      <ul class="list-disc pl-5">
        <li><strong>Purchasing Tokens:</strong> You can buy tokens for monetary value via our payment gateway.</li>
        <li><strong>Earning Tokens:</strong> Add nodes to the Macula mesh to provide computing power to the community and earn tokens.</li>
        <li>Tokens are non-refundable and cannot be exchanged for cash or transferred to other users.</li>
      </ul>

      <h2 class="mt-4 mb-2 font-semibold">5. Subscription Management</h2>
      <p>Users can manage their subscriptions under the "Account" section in the "Settings" screen. Click on "Manage Subscriptions" to view, modify, or cancel your subscription. Subscriptions renew automatically unless canceled before the renewal date.</p>

      <h2 class="mt-4 mb-2 font-semibold">6. User Conduct</h2>
      <p>You agree not to use the Services for any unlawful purpose or in a way that could damage, disable, overburden, or impair our systems. You agree not to attempt to gain unauthorized access to any part of the Services, other users' accounts, or computer systems or networks connected to our Services.</p>

      <h2 class="mt-4 mb-2 font-semibold">7. Intellectual Property</h2>
      <p>All content, trademarks, and other intellectual property on the Swarm Wars website are owned by or licensed to us. You may not use, reproduce, distribute, or create derivative works from our content without express written permission.</p>

      <h2 class="mt-4 mb-2 font-semibold">8. Privacy</h2>
      <p>Your use of our Services is also governed by our Privacy Policy, which describes how we collect, use, and protect your personal information.</p>

      <h2 class="mt-4 mb-2 font-semibold">9. Limitation of Liability</h2>
      <p>To the maximum extent permitted by law, Swarm Wars is not liable for any direct, indirect, incidental, special, consequential, or punitive damages arising out of your use of our Services.</p>

      <h2 class="mt-4 mb-2 font-semibold">10. Indemnification</h2>
      <p>You agree to indemnify and hold Swarm Wars, its affiliates, officers, agents, and employees harmless from any claim or demand, including reasonable attorneys' fees, made by any third party due to or arising out of your use of the Services, your violation of these Terms, or your violation of any rights of another.</p>

      <h2 class="mt-4 mb-2 font-semibold">11. Termination</h2>
      <p>We reserve the right to suspend or terminate your account or access to our Services at any time, with or without cause or notice.</p>
      <h2 class="mt-4 mb-2 font-semibold">12. Changes to Terms</h2>
      <p>We may update these Terms from time to time. We will notify you of any changes by posting the new Terms on the website. Your continued use of the Services after any such changes constitutes your acceptance of the new Terms.</p>

      <h2 class="mt-4 mb-2 font-semibold">13. Governing Law</h2>
      <p>These Terms are governed by and construed in accordance with the laws of the jurisdiction in which Swarm Wars operates, without regard to its conflict of law principles.</p>

      <h2 class="mt-4 mb-2 font-semibold">14. Contact Information</h2>
      <p>If you have any questions about these Terms, please contact us at <a href="mailto:info@discomco.pl">info@discomco.pl</a>.</p>

      <p class="mt-4">By using Swarm Wars, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service.</p>
    </div>
    """
  end
end
