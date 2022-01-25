module HtmlKeyEvents exposing (onKeyDown, onKeyUp)

{-| HTML Event listeners for on 'keyup' and on 'keydown'.
For each one of them, it stops propagation.

[stop]: https://developer.mozilla.org/en-US/docs/Web/API/Event/stopPropagation

@docs onKeyDown, onKeyUp
-}

import Html exposing (Attribute)
import Html.Events exposing (keyCode, stopPropagationOn)
import Json.Decode exposing (Decoder, at, bool, int, map, map2)



{-| It will give you the ASCII code of the key being pressed.
Plus, it will tell you if the `shift` key is pressed as well.
You can read a complete simple example in the README.

    type Msg
        = KeyDown ( Int, Bool )

    view : Html Msg
    view =
        textarea
            [ rows 10
            , cols 40
            , onKeyDown KeyDown
            ]
            []
        ]

    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
        case msg of
            KeyDown ( code, shift ) ->
                (model, Cmd.none)
-}
onKeyDown : (( Int, Bool ) -> msg) -> Attribute msg
onKeyDown tagger =
    stopPropagationOn "keydown" <|
        map alwaysStop (map tagger keyExtractor)



{-| It will give you the ASCII code of the key being released-
You can read a complete simple example in the README.

    type Msg
        KeyUp Int

    view : Html Msg
    view =
        textarea
            [ rows 10
            , cols 40
            , onKeyUp KeyUp
            ]
            []
        ]

    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
        case msg of
            KeyUp code ->
                (model, Cmd.none)
-}
onKeyUp : (Int -> msg) -> Attribute msg
onKeyUp tagger =
    stopPropagationOn "keyup" <|
        map alwaysStop (map tagger keyCode)


keyExtractor : Decoder ( Int, Bool )
keyExtractor =
    map2 Tuple.pair
        (at [ "keyCode" ] int)
        (at [ "shiftKey" ] bool)


alwaysStop : a -> ( a, Bool )
alwaysStop x =
    ( x, True )
