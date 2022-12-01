# JQ filter: press <CR> to execute it

[
  .users[]
  | select(.userId % 2 == 1) # select odd-numbered users
  | {
      fname: .firstName,
      lname: .lastName,
    }
]
