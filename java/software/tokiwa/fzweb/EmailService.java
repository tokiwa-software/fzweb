package software.tokiwa.fzweb;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class EmailService {

    public static Authenticator getPasswordAuthenticator(String username, String password) {
      return new Authenticator() {
        @Override
        protected PasswordAuthentication getPasswordAuthentication() {
          return new PasswordAuthentication(username, password);
        }
      };
    }

}
