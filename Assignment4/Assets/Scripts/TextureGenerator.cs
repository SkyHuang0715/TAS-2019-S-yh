using UnityEngine;
using System.Collections;

public static class TextureGenerator {

    public static Texture2D TextureFromColourMap(Color[] colourMap, int width, int height) {
        Texture2D texture = new Texture2D (width, height);//create a new blank texture
        texture.filterMode = FilterMode.Point;
        texture.wrapMode = TextureWrapMode.Clamp;
        texture.SetPixels (colourMap); //paint pixels to the color map
        texture.Apply (); //apply the texture
        return texture;
    }


    public static Texture2D TextureFromHeightMap(float[,] heightMap) {
        int width = heightMap.GetLength (0);//1 dimension = width
        int height = heightMap.GetLength (1);//2 dimension = height

        Color[] colourMap = new Color[width * height]; //create a new color map
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                colourMap [y * width + x] = Color.Lerp (Color.black, Color.white, heightMap [x, y]);
            }//get all the pixels from the color map, transform noise map to color map
        }

        return TextureFromColourMap (colourMap, width, height);
    }

}
