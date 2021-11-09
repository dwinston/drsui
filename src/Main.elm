module Main exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation as Navigation exposing (Key)
import Html exposing (Html)
import Html.Attributes as Attrs
import Html.Events as Events
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Jwt exposing (Jwt)
import Route exposing (Route)
import Url exposing (Url)
import Url.Builder as Builder


init : Decode.Value -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    let
        jwt =
            case
                Decode.decodeValue (Decode.field "jwt" (Decode.nullable Jwt.decoder)) flags
            of
                Ok jwt_ ->
                    jwt_

                Err e ->
                    Debug.todo (Debug.toString e)
    in
    ( { key = key
      , route = Route.parse url
      , jwt = jwt
      , draftClientId = ""
      , draftClientSecret = ""
      }
    , Cmd.none
    )


type Msg
    = UrlRequest Browser.UrlRequest
    | UrlChange Url
    | UserWantsToLogin
    | UserTypedInClientIdField String
    | UserTypedInClientSecretField String
    | GotLoginResponse (Result Http.Error Jwt)


type alias Model =
    { key : Key
    , route : Route
    , jwt : Maybe Jwt
    , draftClientId : String
    , draftClientSecret : String
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlRequest (Browser.Internal url) ->
            ( model, Navigation.pushUrl model.key (Url.toString url) )

        UrlRequest (Browser.External str) ->
            ( model, Navigation.load str )

        UrlChange url ->
            ( { model | route = Route.parse url }, Cmd.none )

        UserWantsToLogin ->
            ( model
            , Http.post
                { url = "/api/token"
                , expect = Http.expectJson GotLoginResponse (Decode.field "access_token" Jwt.decoder)
                , body =
                    Builder.toQuery
                        [ Builder.string "grant_type" "client_credentials"
                        , Builder.string "client_id" model.draftClientId
                        , Builder.string "client_secret" model.draftClientSecret
                        ]
                        |> String.dropLeft 1
                        |> Http.stringBody "application/x-www-form-urlencoded"
                }
            )

        -- Debug.todo "user wants to log in"
        UserTypedInClientIdField newDraftClientId ->
            ( { model | draftClientId = newDraftClientId }, Cmd.none )

        UserTypedInClientSecretField newDraftClientSecret ->
            ( { model | draftClientSecret = newDraftClientSecret }, Cmd.none )

        GotLoginResponse (Err e) ->
            ( model, Debug.todo (Debug.toString e) )

        GotLoginResponse (Ok jwt) ->
            ( { model | jwt = Just jwt, draftClientId = "", draftClientSecret = "" }, Jwt.save jwt )


view : Model -> Browser.Document Msg
view model =
    { title = "hello"
    , body =
        [ Html.header []
            [ Html.div [] [ Html.text "Header" ]
            , case model.jwt of
                Nothing ->
                    Html.nav []
                        [ Html.a [ Attrs.href "/login" ] [ Html.text "Sign In" ] ]

                Just _ ->
                    Html.nav []
                        [ Html.text "TODO" ]
            ]
        , Html.main_ [] [ viewPageContent model ]

        -- , Html.text <| Debug.toString model
        , Html.footer [] [ Html.text "Footer" ]
        ]
    }


viewPageContent : Model -> Html Msg
viewPageContent model =
    case model.route of
        Route.Login ->
            Html.form [ Events.onSubmit UserWantsToLogin ]
                [ Html.label []
                    [ Html.text "client ID"
                    , Html.input
                        [ Attrs.type_ "text"
                        , Attrs.value model.draftClientId
                        , Events.onInput UserTypedInClientIdField
                        ]
                        []
                    ]
                , Html.label []
                    [ Html.text "client secret"
                    , Html.input
                        [ Attrs.type_ "password"
                        , Attrs.value model.draftClientSecret
                        , Events.onInput UserTypedInClientSecretField
                        ]
                        []
                    ]
                , Html.button [ Attrs.type_ "submit" ] [ Html.text "Log in" ]
                ]

        Route.NotFound ->
            Html.text "NotFound"



-- options now:
--   save jwt to localStorage
--   on successful login, redirect to home page
--   track token expiration to not make a request with a bad token
--   can protect urls with redirect-to-login and route back to requested page
--         this can work for expired jwt tokens as well


main : Program Decode.Value Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = UrlRequest
        , onUrlChange = UrlChange
        }
