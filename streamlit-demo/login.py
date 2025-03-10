import streamlit as st
import utils.auth as auth

ROLES = [None, "Requester", "Responder", "Admin"]

st.title("Login")
def login_page():
    if not st.session_state.current_user:
        login()
    elif st.session_state.step == 'verify_otp':
        otp_verification()
    else:
        select_role()


def login():
    st.title("Passwordless Login")
    print("in login")
    account = st.text_input("enter email", key="account_input")

    if st.button("next"):
        if account:
            session_id = auth.initiate_auth(account)
            st.session_state.current_user = account
            st.session_state.step = "verify_otp"
            st.session_state.login_session_id = session_id
            st.rerun()

def otp_verification():
    st.title("verify OTP")

    otp_input = st.text_input("enter OTP", key="otp_input")
    print("in otp verification")
    if st.button("verify"):
        resp = auth.respond_to_auth_challenge(st.session_state.current_user, otp_input, st.session_state.login_session_id)
        if "AuthenticationResult" in resp:
            st.success("succeed，redirecting...")
            st.session_state.logged_in = True
            st.session_state.step = "success"
            st.session_state.step = 'select_role'
            st.rerun()
        else:
            st.error("OTP incorrect，please retry")

def select_role():
    if not st.session_state.logged_in:
        st.rerun()
    st.header("select role")
    role = st.selectbox("Choose your role", ROLES)

    if st.button("Select"):
        st.session_state.role = role
        st.session_state.step = "succeed"
        st.session_state.logged_in = True
        st.rerun()