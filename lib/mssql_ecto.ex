defmodule MssqlEcto do
  @moduledoc """
  """

  use Ecto.Adapters.SQL, :mssqlex

  alias MssqlEcto.Migration

  import MssqlEcto.Type, only: [encode: 2, decode: 2]

  def autogenerate(:binary_id),       do: Ecto.UUID.generate()
  def autogenerate(type),             do: super(type)

  def dumpers({:embed, _} = type, _), do: [&Ecto.Adapters.SQL.dump_embed(type, &1)]
  def dumpers(:binary_id, _type),     do: []
  def dumpers(:uuid, _type),          do: []
  def dumpers(ecto_type, type),       do: [type, &(encode(&1, ecto_type))]

  def loaders({:embed, _} = type, _), do: [&Ecto.Adapters.SQL.load_embed(type, &1)]
  def loaders(ecto_type, type),       do: [&(decode(&1, ecto_type)), type]

  def supports_ddl_transaction?,      do: Migration.supports_ddl_transaction?

end
