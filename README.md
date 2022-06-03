# tank-game

This is a prototype for a Worms inspired round based artillery game.
The main idea was to try and implement a basic physics engine from scratch.
It only supports circle and polygon collisions with rigid bodies and is far from perfect.
Levels are loaded by parsing SVG files, which allows usage of any vector image editing software to design levels.
Furthermore it is my first time playing around with multithreading outside of web technologies.

This prototype is built using [Processing 4](https://processing.org/) and
it's [Sound Library](https://processing.org/reference/libraries/sound/).
For the destructible environments I used [Clipper](https://github.com/lightbringer/clipper-java) for Java.

## Demo Videos

https://user-images.githubusercontent.com/21311428/171765033-2bf40067-f24f-4161-9ab2-4f8d1b550c06.mp4

https://user-images.githubusercontent.com/21311428/171765112-e364f52b-813f-4a8e-bdfe-4f0b4f36b676.mp4

https://user-images.githubusercontent.com/21311428/171765567-9b32f142-63e3-4ebd-b7aa-59719714aab5.mp4
