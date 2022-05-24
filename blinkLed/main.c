#include "pico/stdlib.h"

void assembly();

void link_gpio_set_dir(int pin, int dir) {
    gpio_set_dir(pin, dir);
}

void link_gpio_put(int pin, int value) {
    gpio_put(pin, value);
}

void main() {
    assembly();
}