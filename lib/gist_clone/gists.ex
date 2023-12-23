defmodule GistClone.Gists do
  @moduledoc """
  The Gists context.
  """

  import Ecto.Query, warn: false
  require Logger
  alias GistClone.Repo

  alias GistClone.Gists.SavedGist
  alias GistClone.Gists.Gist

  @doc """
  Returns the list of gists.

  ## Examples

      iex> list_gists()
      [%Gist{}, ...]

  """
  def list_gists do
    Repo.all(Gist)
  end

  @doc """
  Returns the list of gists belong to the provided user_id.

  ## Examples

      iex> list_gists(user_id)
      [%Gist{}, ...]

  """
  def list_gists(user_id) do
    Gist
    |> where([g], g.user_id == ^user_id)
    |> preload(:user)
    |> Repo.all()
  end

  @doc """
  Returns the list of gists summary that contain comment count and saved_gist count.

  ## Examples

      iex> list_gists(user_id)
      [%Gist{}, ...]

  """

  def list_gists_as_summary() do
    comment_query =
      from(c in GistClone.Comments.Comment,
        group_by: c.gist_id,
        select: %{gist_id: c.gist_id, total_comment: count(c.gist_id)}
      )

    saved_gist_query =
      from(sg in SavedGist,
        group_by: sg.gist_id,
        select: %{gist_id: sg.gist_id, total_saved: count(sg.gist_id)}
      )

    query =
      from(
        g in Gist,
        left_join: c in subquery(comment_query),
        on: c.gist_id == g.id,
        left_join: sg in subquery(saved_gist_query),
        on: sg.gist_id == g.id,
        join: u in assoc(g, :user),
        select: %{
          id: g.id,
          name: g.name,
          user: %{email: u.email},
          description: g.description,
          markup_text: g.markup_text,
          comment_count: coalesce(c.total_comment, 0) |> selected_as(:comment_count),
          saved_gist_count: coalesce(sg.total_saved, 0) |> selected_as(:saved_gist_count),
          updated_at: g.updated_at,
          inserted_at: g.inserted_at
        },
        order_by: [:inserted_at]
      )

    Repo.all(query)
  end

  def get_gist_with_all!(id) do
    Gist
    |> preload(:user)
    |> Repo.get!(id)
  end

  @doc """
  Gets a single gist.

  Raises `Ecto.NoResultsError` if the Gist does not exist.

  ## Examples

      iex> get_gist!(123)
      %Gist{}

      iex> get_gist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gist!(id), do: Repo.get!(Gist, id)

  @doc """
  Creates a gist.

  ## Examples

      iex> create_gist(%{field: value})
      {:ok, %Gist{}}

      iex> create_gist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gist(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:gists)
    |> Gist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gist.

  ## Examples

      iex> update_gist(gist, %{field: new_value})
      {:ok, %Gist{}}

      iex> update_gist(gist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gist(%Gist{} = gist, attrs) do
    gist
    |> Gist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a gist.

  ## Examples

      iex> delete_gist(gist)
      {:ok, %Gist{}}

      iex> delete_gist(gist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gist(%Gist{} = gist) do
    Repo.delete(gist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gist changes.

  ## Examples

      iex> change_gist(gist)
      %Ecto.Changeset{data: %Gist{}}

  """
  def change_gist(%Gist{} = gist, attrs \\ %{}) do
    Gist.changeset(gist, attrs)
  end

  alias GistClone.Gists.SavedGist

  @doc """
  Returns the list of saved_gists.

  ## Examples

      iex> list_saved_gists()
      [%SavedGist{}, ...]

  """
  def list_saved_gists do
    Repo.all(SavedGist)
  end

  @doc """
  Gets a single saved_gist.

  Raises `Ecto.NoResultsError` if the Saved gist does not exist.

  ## Examples

      iex> get_saved_gist!(123)
      %SavedGist{}

      iex> get_saved_gist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_saved_gist!(id), do: Repo.get!(SavedGist, id)

  @doc """
  Creates a saved_gist.

  ## Examples

      iex> create_saved_gist(%{field: value})
      {:ok, %SavedGist{}}

      iex> create_saved_gist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_saved_gist(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:saved_gists)
    |> SavedGist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a saved_gist.

  ## Examples

      iex> update_saved_gist(saved_gist, %{field: new_value})
      {:ok, %SavedGist{}}

      iex> update_saved_gist(saved_gist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_saved_gist(%SavedGist{} = saved_gist, attrs) do
    saved_gist
    |> SavedGist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a saved_gist.

  ## Examples

      iex> delete_saved_gist(saved_gist)
      {:ok, %SavedGist{}}

      iex> delete_saved_gist(saved_gist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_saved_gist(%SavedGist{} = saved_gist) do
    Repo.delete(saved_gist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking saved_gist changes.

  ## Examples

      iex> change_saved_gist(saved_gist)
      %Ecto.Changeset{data: %SavedGist{}}

  """
  def change_saved_gist(%SavedGist{} = saved_gist, attrs \\ %{}) do
    SavedGist.changeset(saved_gist, attrs)
  end

  def count_of_saved_gist_per_gist(id) do
    SavedGist
    |> where([sg], sg.gist_id == ^id)
    |> Repo.aggregate(:count)
  end

  def saved_gist_with_user_and_gist(user_id, gist_id) do
    SavedGist
    |> where([sg], sg.gist_id == ^gist_id)
    |> where([sg], sg.user_id == ^user_id)
    |> Repo.aggregate(:count)
  end

  def delete_saved_gist_using_user_and_gist(user_id, gist_id) do
    SavedGist
    |> where([sg], sg.gist_id == ^gist_id)
    |> where([sg], sg.user_id == ^user_id)
    |> Repo.delete_all()
  end
end
