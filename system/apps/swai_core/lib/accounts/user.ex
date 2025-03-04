defmodule Schema.User do
  require Logger
  use Ecto.Schema

  import Ecto.Changeset
  alias Swai.Defaults, as: Limits

  @all_fields [
    :email,
    :password,
    :confirmed_at,
    :user_alias,
    :bio,
    :image_url,
    :budget,
    :wants_notifications?,
    :has_accepted_terms?
  ]

  @registration_fields [
    :email,
    :user_alias,
    :password,
    :password_confirmation
  ]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field(:email, :string)
    field(:password, :string, virtual: true, redact: false)
    field(:password_confirmation, :string, virtual: true, redact: false)
    field(:hashed_password, :string, redact: true)
    field(:confirmed_at, :naive_datetime)
    field(:user_alias, :string)
    field(:bio, :string)
    field(:image_url, :string)
    field(:budget, :integer, default: 6_000)
    field(:wants_notifications?, :boolean, default: true)
    field(:has_accepted_terms?, :boolean, default: true)
    field(:last_seen, :utc_datetime_usec)
    timestamps()
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.

    * `:validate_email` - Validates the uniqueness of the email, in case
      you don't want to validate the uniqueness of the email (like when
      using this changeset for validations on a LiveView form before
      submitting the form), this option can be set to `false`.
      Defaults to `true`.
  """
  #
  def changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, @all_fields)
    |> validate_required(opts)
  end

  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, @registration_fields)
    |> validate_email(opts)
    |> validate_password(opts)
    |> validate_password_confirmation(opts)
    |> validate_username(opts)
  end

  def username_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:user_alias])
    |> validate_username(opts)
  end

  def budget_changeset(user, attrs, _opts \\ []) do
    user
    |> cast(attrs, [:budget])
    |> validate_number(:budget, greater_than_or_equal_to: 0)
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email])
    |> validate_email(opts)
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Argon2.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Schema.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Argon2.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Argon2.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end

  defp validate_password_confirmation(changeset, opts) do
    changeset
    |> maybe_clear_password_confirmation(opts)

    # Logger.debug("Changeset: #{inspect(changeset)}")
    password = get_change(changeset, :password)
    password_confirmation = get_change(changeset, :password_confirmation)

    # Logger.debug(      "password: #{inspect(password)}, password_confirmation: #{inspect(password_confirmation)}")

    if password == password_confirmation do
      changeset
    else
      changeset
      |> add_error(:password_confirmation, "password confirmation does not match password")
    end
  end

  #################### INTERNALS ####################
  def validate_email(changeset, opts) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> maybe_validate_unique_email(opts)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 72)
    # Examples of additional password validation:
    |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/,
      message: "at least one digit or punctuation character"
    )
    |> maybe_hash_password(opts)
  end

  defp validate_username(changeset, opts \\ []) do
    changeset
    |> validate_required([:user_alias])
    |> validate_length(:user_alias, min: 3, max: 30)
    |> validate_format(:user_alias, ~r/^[a-zA-Z0-9_]+$/,
      message: "can only contain letters, numbers, and underscores"
    )
    |> maybe_validate_unique_username(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # Hashing could be done with `Ecto.Changeset.prepare_changes/2`, but that
      # would keep the database transaction open longer and hurt performance.
      |> put_change(:hashed_password, Argon2.hash_pwd_salt(password))
      |> delete_change(:password)
      |> delete_change(:password_confirmation)
    else
      changeset
    end
  end

  defp maybe_validate_unique_email(changeset, opts) do
    if Keyword.get(opts, :validate_email, true) do
      changeset
      |> unsafe_validate_unique(:email, Swai.Repo)
      |> unique_constraint(:email)
    else
      changeset
    end
  end

  defp maybe_validate_unique_username(changeset, opts) do
    if Keyword.get(opts, :unique_username, true) do
      changeset
      |> unsafe_validate_unique(:user_alias, Swai.Repo)
      |> unique_constraint(:user_alias)
    else
      changeset
    end
  end

  defp maybe_clear_password_confirmation(changeset, opts) do
    if Keyword.get(opts, :clear_password_confirmation, true) do
      changeset
      |> delete_change(:password_confirmation)
    else
      changeset
    end
  end
end
