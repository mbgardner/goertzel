defmodule Goertzel.DTMF do
  # run all the chunks through flow
  # partition by frequencies
  # ignore anything above 0.05 threshold

  @low_freqs [697, 770, 852, 941]

  def process_file do
    file = File.read!("/home/matt/Downloads/audiocheck.net_dtmf_112163_112196_11#9632_##9696.wav")
    header_size = 8 * 44
    <<header::size(header_size), data::binary>> = file

    data
    |> :binary.bin_to_list
    |> Enum.chunk_every(500)
    |> Enum.each(&Goertzel.process_samples(&1, @low_freqs, 8000))
    |> IO.inspect
  end
end