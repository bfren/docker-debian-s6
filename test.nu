use ../index/test.nu

const debian_branches = [
    "12"
    "13"
]

# Run test suite for image
def main [
    debian: string = "13"   # define which Debian version to use
    --all (-a)              # test all registered versions of Debian (overrides $debian)
] {
    let branches = if $all { $debian_branches } else { [$debian] }
    test "debian-s6" $branches
}
