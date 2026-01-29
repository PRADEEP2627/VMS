<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Register | KMCH VMS</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
  @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap');

  body {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    font-family: 'Poppins', sans-serif;
    background: linear-gradient(135deg, #56CCF2, #2F80ED);
    margin: 0;
  }

  .register-card {
    background: #fff;
    width: 400px;
    padding: 40px;
    border-radius: 20px;
    box-shadow: 0 20px 40px rgba(0,0,0,0.2);
  }

  .register-card h3 {
    text-align: center;
    font-weight: 700;
    margin-bottom: 30px;
    color: #2F80ED;
  }

  .form-control {
    border-radius: 25px;
    border: 1.5px solid #ddd;
    padding-left: 15px;
    height: 45px;
    font-size: 1rem;
    transition: border-color 0.3s ease;
  }

  .form-control:focus {
    outline: none;
    border-color: #2F80ED;
    box-shadow: 0 0 8px rgba(47, 128, 237, 0.3);
  }

  .btn-register {
    background: linear-gradient(90deg, #00C6FB, #2F80ED);
    color: #fff;
    border: none;
    border-radius: 30px;
    padding: 12px 0;
    font-weight: 700;
    font-size: 1.1rem;
    cursor: pointer;
    width: 100%;
    transition: background 0.4s ease;
  }

  .btn-register:hover {
    background: linear-gradient(90deg, #2F80ED, #00C6FB);
  }

  .error {
    color: red;
    text-align: center;
    margin-bottom: 15px;
    font-weight: 600;
  }

  .password-mismatch {
    color: #ff4d4d;
    margin-top: -15px;
    margin-bottom: 15px;
    font-size: 0.9rem;
  }
</style>
</head>
<body>

<div class="register-card">
    <h3>Register</h3>
    
    <% if(request.getParameter("error") != null){ %>
        <div class="error">Username already exists!</div>
    <% } %>
    
    <form id="registerForm" action="registerProcess.jsp" method="post" onsubmit="return validatePasswords();">
        <div class="mb-3">
            <label class="form-label">Username</label>
            <input type="text" name="username" class="form-control" required>
        </div>

              <div class="mb-3">
            <label class="form-label">New Password</label>
            <input type="password" id="newPassword" name="newPassword" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Confirm New Password</label>
            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
            <div id="passwordMismatchMsg" class="password-mismatch" style="display:none;">Passwords do not match!</div>
        </div>

        <button type="submit" class="btn btn-register">REGISTER</button>
    </form>
</div>

<script>
  function validatePasswords() {
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const mismatchMsg = document.getElementById('passwordMismatchMsg');
    
    if (newPassword !== confirmPassword) {
      mismatchMsg.style.display = 'block';
      return false; // prevent form submission
    } else {
      mismatchMsg.style.display = 'none';
      return true; // allow form submission
    }
  }
</script>

</body>
</html>
