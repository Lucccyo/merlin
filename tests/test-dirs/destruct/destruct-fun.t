Test case-analysis on a function parameter:

  $ cat >fun.ml <<EOF
  > let f x (bb : bool) y = something
  > EOF

FIXME UPGRADE 5.2: this was working before the upgrade
  $ $MERLIN single case-analysis -start 1:10 -end 1:11 \
  > -filename fun.ml <fun.ml | \
  > sed -e 's/, /,/g' | sed -e 's/ *| */|/g' | tr -d '\n' | jq '.'
  {
    "class": "return",
    "value": [
      {
        "start": {
          "line": 1,
          "col": 9
        },
        "end": {
          "line": 1,
          "col": 11
        }
      },
      "false|true"
    ],
    "notifications": []
  }

  $ cat >fun.ml <<EOF
  > let _ = match true with _ as bb -> bb
  > EOF

  $ $MERLIN single case-analysis -start 1:24 -end 1:25 \
  > -filename fun.ml <fun.ml | \
  > sed -e 's/, /,/g' | sed -e 's/ *| */|/g' | tr -d '\n' | jq '.'
  {
    "class": "return",
    "value": [
      {
        "start": {
          "line": 1,
          "col": 24
        },
        "end": {
          "line": 1,
          "col": 31
        }
      },
      "(false as bb)|(true as bb)"
    ],
    "notifications": []
  }

  $ cat >fun.ml <<EOF
  > let f x ((false as bb) : bool) y = something
  > EOF

FIXME UPGRADE 5.2: this was not working before the upgrade
  $ $MERLIN single case-analysis -start 1:11 -end 1:15 \
  > -filename fun.ml <fun.ml | \
  > sed -e 's/, /,/g' | sed -e 's/ *| */|/g' | tr -d '\n' | jq '.'
  {
    "class": "return",
    "value": [
      {
        "start": {
          "line": 1,
          "col": 15
        },
        "end": {
          "line": 1,
          "col": 15
        }
      },
      "|true -> _"
    ],
    "notifications": []
  }

  $ cat >fun.ml <<EOF
  > let f x (_ as bb : bool) y = something
  > EOF

FIXME UPGRADE 5.2: this was working before the upgrade
  $ $MERLIN single case-analysis -start 1:10 -end 1:10 \
  > -filename fun.ml <fun.ml | \
  > sed -e 's/, /,/g' | sed -e 's/ *| */|/g' | tr -d '\n' | jq '.'
  {
    "class": "return",
    "value": [
      {
        "start": {
          "line": 1,
          "col": 9
        },
        "end": {
          "line": 1,
          "col": 16
        }
      },
      "((false as bb) : bool)|((true as bb) : bool)"
    ],
    "notifications": []
  }
