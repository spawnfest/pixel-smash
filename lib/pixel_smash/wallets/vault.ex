defmodule PixelSmash.Wallets.Vault do
  use GenServer

  alias PixelSmash.Wallets.Wallet

  def start_link(seed_fn) when is_function(seed_fn) do
    GenServer.start_link(__MODULE__, seed_fn, name: __MODULE__)
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

  def init(seed_fn) do
    {:ok, %{}, {:continue, {:seed, seed_fn}}}
  end

  def handle_continue({:seed, seed_fn}, vault) do
    wallets = seed_fn.() ++ []
    vault = Enum.reduce(wallets, vault, &do_put_wallet(&1, &2))
    {:noreply, vault}
  end

  def handle_call(:list_wallets, _from, vault) do
    list =
      vault
      |> Enum.sort(fn {id1, _wallet}, {id2, _wallet} -> id1 <= id2 end)
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
      |> Enum.find(& &1.user_id == id)

    {:reply, wallet, vault}
  end

  def handle_call({:update_wallet, id, update_fn}, _from, vault) do
    with %Wallet{id: old_id} = wallet when not is_nil(wallet) <- vault[id],
         %Wallet{id: ^old_id} = updated_wallet <- update_fn.(wallet) do
      {:reply, updated_wallet, do_put_wallet(vault, updated_wallet)}
    else
      nil -> {:reply, nil, vault}
    end
  end

  defp do_put_wallet(%Wallet{id: id} = wallet, vault) do
    Map.put(vault, id, wallet)
  end
end
