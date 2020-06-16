# GamePad
Sample code and app for reading gamepad inputs and activating rumble motors and leds over wire or bluetooth using HID drivers with user space IOKit.
Apple has released DriverKit, but it requires a paid Apple developer license.
User space IOKit can be used with a free Apple developer license.

Currently supported controllers are Xbox 360 and Dualshock 4 over USB.
Planned for near term support are Dualshock 4 over bluetooth, Xbox One and Nintendo Joy-Cons.
Not planned for near term are bluetooth audio for any controller, Xbox Series X and DualSense support.

Xbox 360 controller for now requires a HID driver not included in this project. For that see [https://github.com/360Controller/360Controller](https://github.com/360Controller/360Controller) (GPL V2 licensed).
Intention for middle to long term is to remove this dependency and communicate directly over USB with this controller.

## License
This project is released under the GPL V3 license, you should have a copy in this repository.
The important code however is the IOKit related portion, so you should be able to see how it works and the byte mappings, and learn how to do it in your own projects.