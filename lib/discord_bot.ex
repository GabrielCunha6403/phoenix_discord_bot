defmodule DiscordBot do

  use Nostrum.Consumer
  alias Nostrum.Api

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    cond do
      String.starts_with?(msg.content, "::gen") -> gen(msg)
      String.starts_with?(msg.content, "::see") -> see(msg)
      String.starts_with?(msg.content, "::shl") -> shuffle(msg)
      String.starts_with?(msg.content, "::menu") -> show_menu(msg)
      true -> :ignore
    end
  end

  defp shuffle(msg) do
    case String.split(msg.content, " ", [parts: 2, trim: true]) do
      ["::shl"] -> Api.create_message(msg.channel_id, "Comando inválido!")
      ["::shl", attr] -> shl_deck(msg, attr)
      _ -> :ignore
    end
  end

  defp show_menu(msg) do
    Api.create_message(msg.channel_id, """
    Lista de comandos:
    ::gen card <CODIGO DA CARTA> -> Cria uma png de card avulso com as instruções H - Paus, S - Espadas, H - Copas e D - Ouros (Ex. ::gen_card 6H);
    ::gen deck -> Gera um deck único e exibe seu ID;
    ::see <ID DO DECK> -> Exibe os cards de um deck por ID;
    ::shl <ID DO DECK> -> Embaralha as cartas do deck por ID;
    """)
  end

  defp gen(msg) do
    case String.split(msg.content, " ", [parts: 3, trim: true]) do
      ["::gen", "card"] -> Api.create_message(msg.channel_id, "Comando inválido!")
      ["::gen", "card", attr] -> gen_card(msg, attr)
      ["::gen", "deck"] -> gen_deck(msg)
      _ -> :ignore
    end
  end

  defp see(msg) do
    case String.split(msg.content, " ", [parts: 2, trim: true]) do
      ["::see"] -> Api.create_message(msg.channel_id, "Comando inválido!")
      # ["::see", attr] -> see_deck(msg, attr)
      _ -> :ignore
    end
  end

  defp gen_card(msg, attr) do
    Api.create_message(msg.channel_id, "https://deckofcardsapi.com/static/img/#{attr}.png")
  end

  defp gen_deck(msg) do
    {:ok, response} = HTTPoison.get("https://www.deckofcardsapi.com/api/deck/new/")
    {:ok, json} = Jason.decode(response.body)
    case Jason.decode(response.body) do
      {:ok, %{"success" => true} = json} ->
        Api.create_message(msg.channel_id, "Novo deck criado com sucesso: #{json["deck_id"]}")
      _ -> Api.create_message(msg.channel_id, "Deu ruim")
    end
  end

  # defp see_deck(msg, attr) do
  #     {:ok, response} = HTTPoison.get("https://www.deckofcardsapi.com/api/deck/#{attr}/draw/?count=5")
  #     {:ok, json} = Jason.decode(response.body)
  #       case Jason.decode(response.body) do
  #         {:ok, %{"success" => true, "cards" => cards}} ->
  #           show_cards(msg, cards)

  #         {:ok, _} ->
  #           Api.create_message(msg.channel_id, "Algo deu errado ao buscar as cartas do deck!")

  #         {:error, _} ->
  #           Api.create_message(msg.channel_id, "Erro ao decodificar a resposta JSON!")
  #       end

  #   end

  defp show_cards(msg, cards) do
    message = Enum.map(cards, fn card -> "#{card["image"]}" end) |> Enum.join("\n")
    Api.create_message(msg.channel_id, "Cards:\n#{message}")
  end

  defp shl_deck(msg, attr) do
    {:ok, response} = HTTPoison.get("https://www.deckofcardsapi.com/api/deck/#{attr}/shuffle/")
    {:ok, json} = Jason.decode(response.body)
    case Jason.decode(response.body) do
      {:ok, %{"success" => true} = json} ->
        Api.create_message(msg.channel_id, "Deck com o ID: #{json["deck_id"]} foi embaralhado")
      _ -> Api.create_message(msg.channel_id, "Deu ruim")
    end

  end

end
