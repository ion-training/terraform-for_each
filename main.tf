variable filename {
    type = list
    default = [
        "apples.txt",
        "oranges.txt",
        "pears.txt"
    ]
}

resource local_file pet {
    for_each = toset(var.filename)
    filename = each.value
}