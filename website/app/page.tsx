import { Hero } from "@/components/hero";
import Mobile from "@/components/mobile";
import { Navbar } from "@/components/header";
// import Footer from "@/components/footer";
import { CallToAction } from "@/components/wait-list";

export default function Home() {
  return (
    <main className="overflow-x-hidden">
      <Navbar />
      <Hero />
      <Mobile />
      <CallToAction />
      {/* <Footer /> */}
    </main>
  );
}
