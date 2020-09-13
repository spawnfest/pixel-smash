defmodule PixelSmash.Wallets.Vault do
  @moduledoc """
  GenServer module to keep Wallets.

  ## Examples

      iex> alias PixelSmash.Wallets.{Vault, Wallet}
      iex>
      ...> pid = start_supervised!({Vault, [restore_fn: fn -> [Wallet.new("user_1", "250.00")] end, name: :test_vault]})
      ...> [%Wallet{deposit: deposit, id: _, user_id: "user_1"}] = Vault.list_wallets(pid)
      ...> true = Decimal.eq?("250.0", deposit)
      iex>
      ...> Vault.put_wallet(pid, Wallet.new("+0", "user_0", 100))
      ...> [%Wallet{id: "+0", user_id: "user_0"}, %Wallet{id: _, user_id: "user_1"}] = Vault.list_wallets(pid)
      iex>
      ...> %Wallet{user_id: "user_1", deposit: deposit} = Vault.get_wallet_by_user(pid, "user_1")
      ...> true = Decimal.eq?("250.0", deposit)
      iex>
      ...> %Wallet{deposit: deposit} = Vault.get_wallet(pid, "+0")
      ...> true = Decimal.eq?(100, deposit)
      iex>
      ...> {:ok, %Wallet{id: "+0", deposit: deposit}} = Vault.update_wallet(pid, "+0", fn wallet -> %{wallet | deposit: Decimal.add(wallet.deposit, 50)} end)
      ...> %Wallet{deposit: ^deposit} = Vault.get_wallet(pid, "+0")
      ...> true = Decimal.eq?(150, deposit)
      iex>
      ...> {:error, :notfound} = Vault.update_wallet(pid, "nonexisting_wallet_id", fn _wallet -> nil end)
      iex>
      iex> # If anonymous function passed to update_wallet returns something other then
      ...> # a wallet then the original wallet stays the same and result of anonymous function
      ...> # is bypassed to caller.
      ...>
      ...> {:error, :reason} = Vault.update_wallet(pid, "+0", fn _wallet -> {:error, :reason} end)
      ...> %Wallet{deposit: deposit} = Vault.get_wallet(pid, "+0")
      ...> true = Decimal.eq?(150, deposit)
  """

  use GenServer

  alias PixelSmash.Wallets.Wallet

  def start_link(opts) do
    restore_fn = Keyword.fetch!(opts, :restore_fn)
    name = Keyword.get(opts, :name, __MODULE__)

    GenServer.start_link(__MODULE__, restore_fn, name: name)
  end

  def list_wallets(pid \\ __MODULE__) do
    GenServer.call(pid, :list_wallets)
  end

  def put_wallet(pid \\ __MODULE__, %Wallet{} = wallet) do
    GenServer.call(pid, {:put_wallet, wallet})
  end

  def get_wallet(pid \\ __MODULE__, id) do
    GenServer.call(pid, {:get_wallet, id})
  end

  def get_wallet_by_user(pid \\ __MODULE__, user_id) do
    GenServer.call(pid, {:get_wallet_by_user, user_id})
  end

  def update_wallet(pid \\ __MODULE__, id, update_fn) when is_function(update_fn) do
    GenServer.call(pid, {:update_wallet, id, update_fn})
  end

  def init(restore_fn) do
    {:ok, %{}, {:continue, {:seed, restore_fn}}}
  end

  def handle_continue({:seed, restore_fn}, vault) do
    wallets = restore_fn.() ++ []
    vault = Enum.reduce(wallets, vault, &do_put_wallet(&1, &2))
    {:noreply, vault}
  end

  def handle_call(:list_wallets, _from, vault) do
    list =
      vault
      |> Enum.sort(fn {id1, _wallet1}, {id2, _wallet2} -> id1 <= id2 end)
      |> Enum.map(fn {_id, wallet} -> wallet end)

    {:reply, list, vault}
  end

  def handle_call({:put_wallet, wallet}, _from, vault) do
    {:reply, wallet, do_put_wallet(wallet, vault)}
  end

  def handle_call({:get_wallet, id}, _from, vault) do
    {:reply, vault[id], vault}
  end

  def handle_call({:get_wallet_by_user, id}, _from, vault) do
    wallet =
      vault
      |> Map.values()
      |> Enum.find(&(&1.user_id == id))

    {:reply, wallet, vault}
  end

  def handle_call({:update_wallet, id, update_fn}, _from, vault) do
    with %Wallet{id: old_id} = wallet when not is_nil(wallet) <- vault[id],
         %Wallet{id: ^old_id} = updated_wallet <- update_fn.(wallet) do
      {:reply, {:ok, updated_wallet}, do_put_wallet(updated_wallet, vault)}
    else
      nil -> {:reply, {:error, :notfound}, vault}
      reply -> {:reply, reply, vault}
    end
  end

  defp do_put_wallet(%Wallet{id: id} = wallet, vault) do
    Map.put(vault, id, wallet)
  end
end
