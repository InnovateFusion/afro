"use client";
import Image from "next/image";
import { motion, useScroll, useTransform } from "framer-motion";
import { useRef } from "react";
import MaskText from "./MaskText";
export default function Mobile() {
  const appImage = useRef<HTMLImageElement>(null);
  const { scrollYProgress } = useScroll({
    target: appImage,
    offset: ["start end", "end end"],
  });

  const rotateX = useTransform(
    scrollYProgress,
    [0, 0.15, 0.25, 0.5, 0.75, 1],
    [0, 0, -5, 3, -3, 2]
  );
  const y = useTransform(
    scrollYProgress,
    [0, 0.15, 0.25, 0.5, 0.75, 1],
    [-550, -500, 0, 500, 1100, 1750]
  );
  const position = useTransform(
    scrollYProgress,
    [0, 0.15, 0.25, 0.5, 0.75, 1],
    [0, 0, 0, -300, 300, -300]
  );
  const scale = useTransform(
    scrollYProgress,
    [0, 0.15, 0.25, 0.5, 0.75, 1],
    [0, 0.3, 0.7, 0.6, 0.7, 0.6]
  );
  const opacity = useTransform(
    scrollYProgress,
    [0, 0.15, 0.25, 0.5, 0.75, 1],
    [0, 0, 1, 1, 1, 1]
  );

  const currentImageIndex = useTransform(
    scrollYProgress,
    [0, 0.15, 0.25, 0.5, 0.75, 1],
    [0, 1, 2, 3, 4, 5]
  );

  const images = [
    "/app0.jpg",
    "/app0.jpg",
    "/app1.jpg",
    "/app3.jpg",
    "/app2.jpg",
    "/app2.jpg",
  ];

  const features = [
    {
      title: "Curated Product Marketplace",
      description:
        " A diverse selection of culturally-inspired fashion, accessories, and tools from Afro Fashion and registered local shops.",
    },
    {
      title: "Customer Chat & Reviews",
      description:
        "Afro Fashion features built-in chat and review systems, allowing customers to ask questions, connect with shop owners, and read verified reviews for informed purchases.",
    },
    {
      title: "Personalized Recommendations",
      description:
        "Afro Fashion uses machine learning to provide personalized recommendations, helping customers find products that match their style and preferences.",
    },
    // {
    //   title: "Multi-language & Currency Support",
    //   description:
    //     "Afro Fashion supports multiple languages and currencies, offering a seamless experience and greater accessibility for international customers.",
    // },
    // {
    //   title: "Social Media Integration & Marketing Tools",
    //   description:
    //     "TikTok integration auto-shares new products, while customer reviews and chat tools enhance vendor engagement.",
    // },
    // {
    //   title: "Shop Management Dashboard",
    //   description:
    //     "Shops manage their storefronts with tools for product listing, inventory tracking, and customer engagement.",
    // },
  ];

  // Instead of creating transforms inside map, create them individually
  const image0Opacity = useTransform(currentImageIndex, (latest) =>
    Math.floor(latest) === 0 ? 1 : 0
  );
  const image1Opacity = useTransform(currentImageIndex, (latest) =>
    Math.floor(latest) === 1 ? 1 : 0
  );
  const image2Opacity = useTransform(currentImageIndex, (latest) =>
    Math.floor(latest) === 2 ? 1 : 0
  );
  const image3Opacity = useTransform(currentImageIndex, (latest) =>
    Math.floor(latest) === 3 ? 1 : 0
  );
  const image4Opacity = useTransform(currentImageIndex, (latest) =>
    Math.floor(latest) === 4 ? 1 : 0
  );
  const image5Opacity = useTransform(currentImageIndex, (latest) =>
    Math.floor(latest) === 5 ? 1 : 0
  );

  const imageOpacityTransforms = [
    image0Opacity,
    image1Opacity,
    image2Opacity,
    image3Opacity,
    image4Opacity,
    image5Opacity
  ];

  return (
    <div className="container mx-auto" ref={appImage}>
      <div className="flex justify-center mp-8 h-[600px]">
        <div className="inline-flex relative">
          <div className="h-full flex items-start justify-center ">
            <motion.div
              className="relative"
              style={{
                opacity: opacity,
                rotateY: rotateX,
                transformPerspective: "800px",
                y: y,
                left: position,
                scale: scale,
              }}
              initial={{ y: 0, opacity: 1, scale: 0.6 }}
              transition={{ duration: 2, damping: 10, stiffness: 100 }}
            >
              {/* <div className="absolute inset-0 flex items-center justify-center"> */}
              <motion.div>
                {images.map((src, index) => (
                  <motion.div
                    className="absolute inset-0 flex items-center justify-center"
                    key={src}
                    style={{
                      position: "absolute",
                      width: "100%",
                      height: "100%",
                      opacity: imageOpacityTransforms[index]
                    }}
                  >
                    <Image
                      src={src}
                      alt={`Fashion mobile app ${index + 1}`}
                      width={345}
                      height={745}
                      className="rounded-[50px]"
                    />
                  </motion.div>
                ))}
              </motion.div>
              {/* </div> */}
              <Image
                src="/mobile.webp"
                alt="Fashion mobile app cover"
                width={375}
                height={812}
                className="rounded-3xl"
              />
            </motion.div>
          </div>
          <motion.div
            className="absolute right-[398px] top-[8px] hidden sm:inline cursor-pointer"
            drag
            dragConstraints={{
              left: -300,
              right: 300,
              top: -300,
              bottom: 300,
            }}
            dragSnapToOrigin
            whileHover={{ scale: 1.2 }}
            whileTap={{ scale: 0.8 }}
          >
            <Image
              src={"/clothes/9.png"}
              alt="cursor"
              height={200}
              width={200}
              className="max-w-none"
              draggable="false"
            />
          </motion.div>
          <motion.div
            className="absolute right-[598px] top-[158px] hidden sm:inline cursor-pointer"
            drag
            dragConstraints={{
              left: -300,
              right: 300,
              top: -300,
              bottom: 300,
            }}
            dragSnapToOrigin
            whileHover={{ scale: 1.2 }}
            whileTap={{ scale: 0.8 }}
          >
            <Image
              src={"/clothes/2.png"}
              alt="cursor"
              height={200}
              width={200}
              className="max-w-none"
              draggable="false"
            />
          </motion.div>
          <motion.div
            className="absolute right-[398px] top-[308px] hidden sm:inline cursor-pointer"
            drag
            dragConstraints={{
              left: -300,
              right: 300,
              top: -300,
              bottom: 300,
            }}
            dragSnapToOrigin
            whileHover={{ scale: 1.2 }}
            whileTap={{ scale: 0.8 }}
          >
            <Image
              src={"/clothes/8.png"}
              alt="cursor"
              height={200}
              width={200}
              className="max-w-none"
              draggable="false"
            />
          </motion.div>
          <motion.div
            className="absolute left-[378px] top-[6px] hidden sm:inline cursor-pointer"
            drag
            dragConstraints={{
              left: -300,
              right: 300,
              top: -300,
              bottom: 300,
            }}
            dragSnapToOrigin
            whileHover={{ scale: 1.2 }}
            whileTap={{ scale: 0.8 }}
          >
            <Image
              src={"/clothes/11.png"}
              alt="cursor"
              height={200}
              width={200}
              className="max-w-none"
              draggable="false"
            />
          </motion.div>
          <motion.div
            className="absolute left-[578px] top-[156px] hidden sm:inline cursor-pointer"
            drag
            dragConstraints={{
              left: -300,
              right: 300,
              top: -300,
              bottom: 300,
            }}
            dragSnapToOrigin
            whileHover={{ scale: 1.2 }}
            whileTap={{ scale: 0.8 }}
          >
            <Image
              src={"/clothes/16.png"}
              alt="cursor"
              height={200}
              width={200}
              className="max-w-none"
              draggable="false"
            />
          </motion.div>
          <motion.div
            className="absolute left-[378px] top-[306px] hidden sm:inline cursor-pointer"
            drag
            dragConstraints={{
              left: -300,
              right: 300,
              top: -300,
              bottom: 300,
            }}
            dragSnapToOrigin
            whileHover={{ scale: 1.2 }}
            whileTap={{ scale: 0.8 }}
          >
            <Image
              src={"/clothes/13.png"}
              alt="cursor"
              height={200}
              width={200}
              className="max-w-none"
              draggable="false"
            />
          </motion.div>
        </div>
      </div>
      {features.map((feature, index) => (
        <div
          key={index}
          className={`grid grid-cols-1 md:grid-cols-2 text-  h-[600px] p-4 md:p-20 items-center`}
        >
          {index % 2 === 0 && <div></div>}

          <div className={`text-center ${index % 2 == 1 ? "float-end" : ""}`}>
            <MaskText
              className="text-5xl text- /70  mt-5 text-center"
              phrases={[feature.title]}
              direction={index % 2 === 1 ? "left" : "right"}
              tag="h1"
            />
            {}
            <MaskText
              className={`text-xl mt-5 text-center ${index % 2 == 1 ? "" : ""}`}
              phrases={[feature.description]}
              direction={index % 2 === 1 ? "left" : "right"}
              tag="p"
            />
          </div>
          {index % 2 === 1 && <div></div>}
          <div className="block h-64 md:hidde"></div>
        </div>
      ))}
    </div>
  );
}
