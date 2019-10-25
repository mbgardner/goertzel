defmodule Goertzel do

  def process_samples(samples, freqs, rate) do
    Enum.each(freqs, fn f ->
      k = get_coefficient(f, rate)
      do_process_samples(samples, k, {0, 0, 0, 0})
      |> IO.inspect(label: f)
    end)
  end

  defp do_process_samples([sample | []], k, {s1, s2, total, count}) do
    get_final_power(k, s1, s2, sample, total, count + 1)
  end

  defp do_process_samples([sample | samples], k, {s1, s2, total, count}) do
    {s1, s2, t} = get_power(k, sample, s1, s2, total)

    do_process_samples(samples, k, {s1, s2, t, count + 1})
  end

  defp get_power(k, sample, s1, s2, total) do
    sine = (sample + (k * s1)) - s2
    s2 = s1
    s1 = sine

    # power = ((s1 * s1) + (s2 * s2)) - (k * s1 * s2)
    t = total + (sample * sample)

    t =
      if t == 0 do
        1
      else
        t
      end

    {s1, s2, t}
  end

  defp get_final_power(k, s1, s2, sample, total, count) do
    sine = (sample + (k * s1)) - s2
    s2 = s1
    s1 = sine

    power = ((s1 * s1) + (s2 * s2)) - (k * s1 * s2)
    t = total + (sample * sample)
    
    power / t / count
  end

  defp get_coefficient(freq, rate) do
    2 * :math.cos(2 * :math.pi() * (freq / rate))
  end
  @moduledoc """
  Documentation for Goertzel.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Goertzel.hello()
      :world

  """
  def hello do
    :world
  end
end
