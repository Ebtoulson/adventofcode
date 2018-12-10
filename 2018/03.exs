defmodule Claim do
	defstruct [:id, :x, :y, :width, :height]
end

defmodule Fabric do
	def parse_claims(filename \\ "03.txt") do
		filename
		|> File.read!()
		|> String.split("\n")
		|> Enum.map(&parse_claim/1)
	end

	def build_grid(claims) do
		[]
		|> List.duplicate(max_width(claims))
		|> List.duplicate(max_height(claims))
	end

	def populate_grid(original_grid, claims) do
		Enum.reduce(claims, original_grid, fn(claim, grid) ->
			Enum.reduce(claim.y..(claim.y + claim.height - 1), grid, fn(y, inner_grid) ->

				row = Enum.reduce(claim.x..(claim.x + claim.width - 1), Enum.at(inner_grid, y), fn(x, row) ->
					List.update_at(row, x, &([claim.id | &1]))
				end)

				List.update_at(inner_grid, y, fn(_)-> row end)
			end)
		end)
	end

	def overlap(grid) do
		grid
		|> Enum.flat_map(&(&1))
		|> Enum.count(&(Enum.count(&1) > 1))
	end

	def no_overlap(grid) do
		flattened = Enum.flat_map(grid, &(&1))

		overlapped =
			Enum.reduce(flattened, [], fn(x, overlap_list) ->
				if Enum.count(x) > 1 do
					Enum.reduce(x, overlap_list, fn(k, l) ->
						[k | l]
					end)
				else
					overlap_list
				end
			end)
			|> Enum.uniq()

		grid
		|> List.flatten()
		|> Enum.uniq()
		|> Kernel.--(overlapped)
	end

	defp max_height(claims) do
		claims
		|> Enum.map(fn(claim) -> claim.height + claim.y  end)
		|> Enum.max()
	end

	defp max_width(claims) do
		claims
		|> Enum.map(fn(claim) -> claim.width + claim.x  end)
		|> Enum.max()
	end

	defp parse_claim(claim) do
		[_, id, x, y, width, height] =
			~r/\#(\d+) \@ (\d+),(\d+)\: (\d+)x(\d+)/
			|> Regex.run(claim)

		%Claim{
			id: id,
			x: to_int(x),
			y: to_int(y),
			width: to_int(width),
			height: to_int(height)
		}
	end

	defp to_int(s) do
		String.to_integer(s)
	end
end


claims = Fabric.parse_claims()

grid =
	claims
	|> Fabric.build_grid()
	|> Fabric.populate_grid(claims)

# grid
# |> Fabric.overlap()
# |> IO.inspect

grid
|> Fabric.no_overlap()
|> IO.inspect
