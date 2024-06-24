defmodule Examples.ECrypto do
  use Memoize

  require ExUnit.Assertions
  import ExUnit.Assertions

  alias Anoma.Crypto.Sign
  alias Anoma.Crypto.Symmetric
  alias Anoma.Crypto.Id

  ####################################################################
  ##                              IDs                               ##
  ####################################################################

  @spec alice() :: Id.t()
  defmemo alice() do
    Id.new_keypair()
  end

  @spec bertha() :: Id.t()
  defmemo bertha() do
    Id.new_keypair()
  end

  @spec eve() :: Id.t()
  defmemo eve() do
    Id.new_keypair()
  end

  @spec londo() :: Id.t()
  defmemo londo() do
    keys = Id.new_keypair()

    assert keys == keys |> Id.salt_keys(xcc()) |> Id.unsalt_keys(xcc()),
           "unsalt · salt ≡ identity"

    keys
  end

  ####################################################################
  ##                           Symmetric                            ##
  ####################################################################

  @spec xcc() :: Symmetric.t()
  defmemo xcc() do
    sym = Symmetric.random_xchacha()

    assert 555 == Symmetric.encrypt(555, sym) |> Symmetric.decrypt(sym),
           "decrypt · encrypt ≡ identity"

    sym
  end

  ####################################################################
  ##                         Signed Messages                        ##
  ####################################################################

  def blood_msg() do
    "The blood is already on my hands. Right or wrong, .. I must follow the path .. to its end."
  end

  @spec blood_l_signed_detached() :: binary()
  def blood_l_signed_detached() do
    msg = Sign.sign_detached(blood_msg(), londo().internal.sign)
    assert Sign.verify_detached(msg, blood_msg(), londo().external.sign)
    msg
  end

  @spec blood_l_signed() :: binary()
  def blood_l_signed() do
    msg = Sign.sign(blood_msg(), londo().internal.sign)
    assert Sign.verify(msg, londo().external.sign)
    msg
  end
end
