defmodule Ecto.Adapters.MSSQL do
  @moduledoc false
  @behaviour Ecto.Adapter.Storage

  use Ecto.Adapters.SQL, :mssqlex_v3

  alias Ecto.Adapters.MSSQL.Migration
  alias Ecto.Adapters.MSSQL.Storage
  alias Ecto.Adapters.MSSQL.Structure

  import Ecto.Adapters.MSSQL.Type, only: [encode: 2, decode: 2]

  def autogenerate(:binary_id), do: Ecto.UUID.generate()
  def autogenerate(type), do: super(type)

  def dumpers({:embed, _} = type, _),
    do: [&Ecto.Adapters.SQL.dump_embed(type, &1)]

  def dumpers(:binary_id, _type), do: []
  def dumpers(:uuid, _type), do: []
  def dumpers(ecto_type, type), do: [type, &encode(&1, ecto_type)]

  def loaders({:embed, _} = type, _),
    do: [&Ecto.Adapters.SQL.load_embed(type, &1)]
  def loaders(:date, type), do: [&load_date(&1)]

  def loaders(ecto_type, type), do: [&decode(&1, ecto_type), type]

  def load_date(value), do: Ecto.Type.cast(:date, value)

  ## Migration
  def supports_ddl_transaction?, do: Migration.supports_ddl_transaction?()

  ## Storage
  def storage_up(opts), do: Storage.storage_up(opts)
  def storage_down(opts), do: Storage.storage_down(opts)

  ## Structure
  def structure_dump(default, config),
    do: Structure.structure_dump(default, config)

  def structure_load(default, config),
    do: Structure.structure_load(default, config)
end
