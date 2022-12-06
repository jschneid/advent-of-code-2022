namespace advent_of_code_2022
{
    public class Day6Part2
    {
        public static void Main(string[] args)
        {
            string input = File.ReadAllText("input.txt");
            string possibleMarker;
            int index = -1;
            do {
                index++;
                possibleMarker = input.Substring(index, 14);
            } while (!HasOnlyUniqueCharacters(possibleMarker));

            Console.WriteLine(index + 14);
        }

        private static bool HasOnlyUniqueCharacters(string possibleMarker)
        {
            for (int i = 0; i < possibleMarker.length; i++)
            {
                for (int j = i + 1; j < possibleMarker.length; j++)
                {
                    return false if (possibleMarker[i] == possibleMarker[j]);
                }
            }
            return true;
        }
    }
}