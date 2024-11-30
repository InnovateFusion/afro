import Link from "next/link";
import { Button } from "../ui/button";
import { getSession, logout } from "@/lib/actions/user.actions";
import { redirect } from "next/navigation";

export default async function NavbarButton() {
  const session = await getSession();
  return (
    <>
      {session ? (
        <form
          action={async () => {
            "use server";
            await logout();
            redirect("/");
          }}
        >
          <Button variant="outline" type="submit">
            Logout
          </Button>
        </form>
      ) : (
        <Link href="/login">
          <Button>Login</Button>
        </Link>
      )}
    </>
  );
}
