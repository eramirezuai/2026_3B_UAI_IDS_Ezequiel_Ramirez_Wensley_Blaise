using Fletex.Business;
using System;
using System.Windows.Forms;

namespace Fletex.GUI
{
    public partial class FormLogin : Form
    {
        private UserBusiness userBLL;
        public string userName;
        public FormLogin()
        {
            InitializeComponent();
            userBLL = new UserBusiness();
        }

        private void btn_login_Click(object sender, EventArgs e)
        {
            try
            {
                var user = userBLL.LoginWithCredentials(txt_user.Text, txt_password.Text);
                //MessageBox.Show("User " + user.Name + "logged in");
                this.Close();

            }
            catch (Exception ex)
            {

                MessageBox.Show(ex.Message);
            }
        }

        private void FormLogin_Load(object sender, EventArgs e)
        {
            this.ControlBox = false;
            //temporal
            txt_user.Text = "admin01";
            txt_password.Text = "admin01";
            
        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }
    }
}
