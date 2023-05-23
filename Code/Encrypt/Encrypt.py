import string

class Rotor:
    def __init__(self, wiring, notch):
        self.wiring = wiring
        self.notch = notch
        self.position = 0

    def set_position(self, position):
        self.position = position % len(self.wiring)

    def encrypt_forward(self, letter):
        offset = (ord(letter) - ord('A') + self.position) % 26
        encrypted_offset = (ord(self.wiring[offset]) - ord('A') - self.position) % 26
        encrypted_letter = chr(encrypted_offset + ord('A'))
        return encrypted_letter

    def encrypt_backward(self, letter):
        offset = (ord(letter) - ord('A') + self.position) % 26
        encrypted_offset = (self.wiring.index(chr(offset + ord('A'))) - self.position) % 26
        encrypted_letter = chr(encrypted_offset + ord('A'))
        return encrypted_letter

class Reflector:
    def __init__(self, wiring):
        self.wiring = wiring

    def encrypt(self, letter):
        offset = ord(letter) - ord('A')
        encrypted_offset = ord(self.wiring[offset]) - ord('A')
        encrypted_letter = chr(encrypted_offset + ord('A'))
        return encrypted_letter

class EnigmaMachine:
    def __init__(self, rotors, reflector):
        self.rotors = rotors
        self.reflector = reflector

    def set_rotor_positions(self, positions):
        for i, rotor in enumerate(self.rotors):
            rotor.set_position(positions[i])

    def encrypt(self, message):
        encrypted_message = ''
        for letter in message.upper():
            if letter in string.ascii_uppercase:
                for rotor in self.rotors:
                    letter = rotor.encrypt_forward(letter)
                letter = self.reflector.encrypt(letter)
                for rotor in reversed(self.rotors):
                    letter = rotor.encrypt_backward(letter)
                encrypted_message += letter
                self.rotate_rotors()
        return encrypted_message

    def rotate_rotors(self):
        rotate_next = True
        for rotor in self.rotors:
            if rotate_next:
                rotor.position = (rotor.position + 1) % 26
                if rotor.position != rotor.notch:
                    rotate_next = False
            else:
                break

# Example usage:
rotor1 = Rotor("EKMFLGDQVZNTOWYHXUSPAIBRCJ", ord('Q') - ord('A'))
rotor2 = Rotor("AJDKSIRUXBLHWTMCQGZNPYFVOE", ord('E') - ord('A'))
rotor3 = Rotor("BDFHJLCPRTXVZNYEIWGAKMUSQO", ord('V') - ord('A'))
reflector = Reflector("YRUHQSLDPXNGOKMIEBFZCWVJAT")

enigma = EnigmaMachine([rotor1, rotor2, rotor3], reflector)
enigma.set_rotor_positions([0, 0, 0])

message = "HELLO"
encrypted_message = enigma.encrypt(message)
print("Encrypted Message:", encrypted_message)
