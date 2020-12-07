defmodule StructTranslater do
  require Logger

  @doc """
    +----------------+\n
    | to atom struct |\n
    +----------------+\n
    translate a map with string-key to atom-key recursively.
  """
  def to_atom_struct(list) when is_list(list) do
    Enum.map(list, fn ele ->
      to_atom_struct(ele)
    end)
  end

  def to_atom_struct(struct) when is_map(struct) do
    for {key, val} <- struct, into: %{}, do:
    {translate_key(key), to_atom_struct(val)}

  end

  def translate_key(key) when is_atom(key),do: key
  def translate_key(key), do: String.to_atom(key)

  def to_atom_struct(else_ele) do
    else_ele
  end

  #  +----------------+
  #  | struct <=> map |
  #  +----------------+

  @spec struct_to_map(atom | %{:__struct__ => atom, optional(atom) => any}) :: map
  def struct_to_map(struct) do
    map =
      struct
      |> Map.from_struct()
      |> Map.delete(:__meta__)

    :maps.filter(fn _, v -> Ecto.assoc_loaded?(v) end, map)
  end

  @doc """
    e.g.: map_to_struct(Asset, params_map)
  """
  @spec map_to_struct(atom(), map()) :: Struct.t()
  def map_to_struct(kind, attrs) do
    struct = struct(kind)

    Enum.reduce(Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(attrs, Atom.to_string(k)) do
        {:ok, v} ->
          %{acc | k => v}

        :error ->
          case Map.fetch(attrs, k) do
            {:ok, v} -> %{acc | k => v}
            :error -> acc
          end
      end
    end)
  end

  @doc """
    +------------+\n
    | map => str |\n
    +------------+\n
  """
  def map_to_str(map) when is_nil(map), do: nil
  def map_to_str(map), do: Poison.encode!(map)
end
