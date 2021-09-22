def colorize_text(text: str, color: str) -> str:
    markers = {
        "red": "\033[1;31m",
        "green": "\033[1;32m",
        "yellow": "\033[1;33m",
        "blue": "\033[1;34m",
        "purple": "\033[1;35m",
        "cyan": "\033[1;36m",
        "white": "\033[1;37m",
        "reset": "\033[0m",
    }

    return "{}{}{}".format(markers[color], text, markers["reset"])
