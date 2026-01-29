<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Login | KMCH VMS</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet" />

<style>
  @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap');

  body, html {
    height: 100%;
    margin: 0;
    font-family: 'Poppins', sans-serif;

background: linear-gradient(135deg, #4ade80, #7dd3fc, #f8fafc);
color: #0f172a;
font-weight: 600;


    display: flex;
    align-items: center;
    justify-content: center;
  }

  .container {
    max-width: 900px;
    width: 100%;
    height: 500px;
    background: #fff;
    border-radius: 20px;
    display: flex;
    overflow: hidden;
    box-shadow: 0 20px 50px rgba(0,0,0,0.2);
  }

  .left-panel {
    flex: 1;
    background: linear-gradient(135deg, #56CCF2, #2F80ED);
    color: white;
    padding: 50px 40px;
    position: relative;
    display: flex;
    flex-direction: column;
    justify-content: center;
    overflow: hidden;
  }

  .left-panel h1 {
    font-weight: 700;
    font-size: 2.5rem;
    margin-bottom: 20px;
    color: ;
  }

  .left-panel p {
    font-size: 1rem;
    line-height: 1.5;
    opacity: 0.9;
    color: white;
  }

  /* Abstract shapes on left panel */
 

  .right-panel {
    flex: 1;
    background: white;
    padding: 60px 40px;
    display: flex;
    flex-direction: column;
    justify-content: center;
  }

  .right-panel h4 {
    text-align: center;
    color: #2F80ED; /* darker blue */
    font-weight: 700;
    letter-spacing: 1.2px;
    margin-bottom: 25px;
  }

  .form-group {
    position: relative;
    margin-bottom: 20px;
  }

  input.form-control {
    border-radius: 25px;
    padding-left: 40px;
    border: 1.5px solid #ddd;
    font-size: 1rem;
    height: 45px;
    transition: border-color 0.3s ease;
  }

  input.form-control:focus {
    outline: none;
    border-color: #2F80ED;
    box-shadow: 0 0 8px rgba(47, 128, 237, 0.3);
  }

  /* Icons inside inputs */
  .form-group .bi {
    position: absolute;
    top: 50%;
    left: 15px;
    transform: translateY(-50%);
    color: #bbb;
    font-size: 1.2rem;
  }

  .options {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 0.85rem;
    color: #666;
    margin-bottom: 25px;
  }

  .options label {
    display: flex;
    align-items: center;
    cursor: pointer;
  }

  .options input[type="checkbox"] {
    margin-right: 8px;
    width: 16px;
    height: 16px;
  }

  .options a {
    color: #2F80ED;
    text-decoration: none;
    transition: color 0.3s ease;
  }

  .options a:hover {
    color: #00C6FB;
  }

  .btn-login {
    background: linear-gradient(90deg, #00C6FB, #2F80ED);
    border: none;
    border-radius: 25px;
    color: white;
    font-weight: 700;
    font-size: 1.1rem;
    padding: 12px 0;
    cursor: pointer;
    width: 100%;
    transition: background 0.4s ease;
  }

  .btn-login:hover {
    background: linear-gradient(90deg, #2F80ED, #00C6FB);
  }

  .error {
    color: red;
    font-weight: 600;
    text-align: center;
    margin-bottom: 15px;
  }

  .signup-text {
    text-align: center;
    margin-top: 30px;
  }

  .signup-text a {
    color: #2F80ED;
    font-weight: 700;
    text-decoration: none;
    transition: color 0.3s ease;
  }

  .signup-text a:hover {
    color: #00C6FB;
  }

  /* Responsive */
  @media (max-width: 768px) {
    .container {
      flex-direction: column;
      height: auto;
      width: 90%;
      border-radius: 15px;
    }
    .left-panel, .right-panel {
      padding: 30px 20px;
    }
  }
</style>

</head>
<body>

<div class="container">

  <div class="left-panel">
    <h1>Welcome to KMCH</h1>
    <p>Life is sweet/beautiful<div class="shape shape1"></div>
    <div class="shape shape2"></div>
    <div class="shape shape3"></div>
    <div class="shape shape4"></div>
  </div>

  <div class="right-panel">
    <h4>USER LOGIN</h4>

    <% if(request.getParameter("error") != null){ %>
      <div class="error">Invalid Username or Password</div>
    <% } %>

    <form action="<%=request.getContextPath()%>/CMS/loginProcess.jsp" method="post" autocomplete="off">

      <div class="form-group">
        <i class="bi bi-person"></i>
        <input type="text" name="username" class="form-control" placeholder="Username" required />
      </div>

      <div class="form-group password-wrapper">
        <i class="bi bi-lock"></i>
        <input type="password" id="password" name="password" class="form-control" placeholder="Password" required />
        <i class="bi bi-eye-slash" id="togglePassword" title="Show/Hide Password" style="right: 15px; left: auto; cursor:pointer; position:absolute; top:50%; transform: translateY(-50%); color:#888;"></i>
      </div>

      <div class="options">
        <label><input type="checkbox" name="remember" /> Remember</label>
        <a href="#">Forgot password?</a>
      </div>

      <button type="submit" class="btn-login">LOGIN</button>
    </form>

    <div class="signup-text">
      Don't have an account? <a href="register.jsp">SIGN UP</a>
    </div>
  </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
  const togglePassword = document.getElementById('togglePassword');
  const passwordInput = document.getElementById('password');

  togglePassword.addEventListener('click', () => {
    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
    passwordInput.setAttribute('type', type);
    togglePassword.classList.toggle('bi-eye');
    togglePassword.classList.toggle('bi-eye-slash');
  });
</script>

</body>
</html>
