defmodule FacebookLoginTest do
  use Hound.Helpers
  use ExUnit.Case

  hound_session(
    driver: %{
      chromeOptions: %{
        "args" => [
          "--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.104 Safari/537.36",
          #"--headless",
          "--disable-gpu"
        ]
      }
    }
  )


  #Testing Login
  @tag timeout: 60000
  test "email is malformed" do
    IO.puts "There are x steps in this test. \nStep 1: Open URL"
    #Open url
    navigate_to "https://facebook.com"
    IO.puts "Pass"

    IO.puts "Step 2: populate the malformed email and password fields."
    find_element(:name, "email")
    |> fill_field("emaildfgdzxfvgmail.com")
    find_element(:name, "pass")
    |> fill_field("test")
    IO.puts "Pass"

    IO.puts "Step 3: find and click on the login/submit button"
    element?(:name, "login")
    find_element(:name, "login")
    |> click()
    IO.puts "Pass"

    IO.puts "Step 4: Wait for error box"
    Retryer.element_visible?({:css, "#error_box > div.fsl.fwb.fcb"}, 10)
    IO.puts "Pass"

    IO.puts "Step 5: validate that there is an error"
    assert element?(:css, "#error_box > div.fsl.fwb.fcb")
    IO.puts "Test Passes"
  end

  @moduletag timeout: 60000
  test "Create a page" do
    IO.puts "\nThere are 5 steps in this test. \nStep 1: Open url"
    navigate_to("https://facebook.com")
    IO.puts "Pass"

    IO.puts "Step 2: Wait for Create a page link to be on page."
    Retryer.element_visible?({:link_text, "Create a Page"}, 1000)
    IO.puts "Pass"

    IO.puts "Step 3: Click on Create a page link."
    find_element(:link_text, "Create a Page")
    |> click()
    IO.puts "Pass"

    IO.puts "Step 4: Click on the get started button. Business."
    find_element(
      :css,
      "#content > div > div._63f3 > div > div:nth-child(2) > table > tbody > tr > td:nth-child(1) > div > div._3a5o._38gw > div._4zcq > button > div > div"
    )
    |> click()
    IO.puts "Pass"

    IO.puts "#Step 5: assert The you must be logged in yellow box is present."
    Retryer.element_visible?({:css, "#login_form > div.pam._9ay2.uiBoxYellow"}, 10)
    IO.puts "Test Passes"
  end

  @moduletag timeout: 60000
  test "Create an account" do

        IO.puts "\nThere are 5 steps in this test. \nStep 1: Open url"
    navigate_to("https://facebook.com")
    IO.puts "Pass"

    IO.puts "Step 2: Wait for Create an account button to be on page."
    Retryer.element_visible?({:id, "u_0_2"}, 1000)
    IO.puts "Pass"

    IO.puts "Step 3: Click on the Create account button."
    find_element(:id, "u_0_2")
    |> click()
    IO.puts "Pass"

    IO.puts "Step 4: Clear and populate firstname"
    clear_field({:name, "firstname"})
    find_element(:name, "firstname")
    |> fill_field("somefirstname")
    IO.puts "Pass"

    IO.puts "Step 5: clear and populate lastname"
    clear_field({:name, "lastname"})
    find_element(:name, "lastname")
    |> fill_field("somelastname")
    IO.puts "Pass"

    IO.puts "Step 6: populate email address and confirm email address"
    clear_field({:name, "reg_email__"})
    find_element(:name, "reg_email__")
    |> fill_field("phone@number.com")
    send_keys(:tab)
    send_text("phone@number.com")
    IO.puts "Pass"

    IO.puts "Step 8: enter a password"
    #clear_field(:id, "password_step_input")
    find_element(:id, "password_step_input")
    |> fill_field("sdlfgghnsdlofgjmsedi!")
    IO.puts "Pass"

    IO.puts "Step 9: Select the year dropdown and select option 53(1905)"
    find_element(:css, "#year option[value='1905']")
    |> click()
    IO.puts "Pass"

    #:timer.sleep(:timer.seconds(60))
    IO.puts "step 10: Click on male"
    ele = find_element(:class, "_n3" )
    reg = find_within_element(ele, :id, "reg")
    ref_box = find_within_element(reg, :id, "reg_form_box")
    gender = find_within_element(ref_box, :class, "_5wa2")
    gender_wraper = find_within_element(gender, :class, "_5k_3")
    |> click()
    IO.puts "Pass"

    IO.puts "step 11: find submit element, Dont click"
    try do
      submit_div = find_element(:class, "_1lch--")
    rescue
      Hound.NoSuchElementError -> take_screenshot("test/screenshots/ErrorFindingSignupbutton.jpg")
      IO.puts "Error finding Signup Button. View Screenshot for details."
      raise Hound.NoSuchElementError
    end
        # |> click()
    IO.puts "Test Passes"
  end

  test "" do

  end
end




#Screenshot.take("pressed")
#:timer.sleep(:timer.seconds(60))

defmodule Retryer do
  import Hound.Helpers.Element
  @retry_time 1000

  def element_visible?(element, retries \\ 5) do
    if retries > 0 do
      case element_displayed?(element) do
        true -> true
        false ->
          :timer.sleep(@retry_time)
          element_visible?(element, retries - 1)
      end
    else
      element_displayed?(element)
    end
  end
end

defmodule Screenshot do

  def take(filename) do
    use Hound.Helpers
    try do
      filename = "test/screenshots/facebookLogin-#{filename}.png"
      IO.puts filename
      take_screenshot(filename)
    catch
      FunctionClauseError -> IO.puts "Error saving screenshot."
    end
  end
end
